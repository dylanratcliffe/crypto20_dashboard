require 'rest-client'
require 'json'

requests      = []
points        = []
labels        = []
last_x        = 1
current_value = 0

SCHEDULER.every '3s' do
  # Do all external requests in parallel
  requests = {
    main: 'https://www.crypto20.com/status',
    eth:  'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD',
    btc:  'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD',
    ltc:  'https://min-api.cryptocompare.com/data/price?fsym=LTC&tsyms=USD',
  }
  threads = []

  # Start a new thread to do each request
  requests.each do |name, url|
    threads << Thread.new do
      requests[name] = JSON.parse(RestClient.get(url).body)
    end
  end

  # Wait for all to complete
  threads.each { |t| t.join }

  # store the main response to save code
  response = requests[:main]

  # Get current value for graph
  current_value = requests[:main]['usd_value']
  # Send an event to update the number but not the whole graph
  send_event('usd_value', value: current_value)

  # Calculate percetage
  growth = (((response['usd_value'].to_f / response['presale'].to_f) - 1)*100).round(1)
  send_event('growth', value: growth)

  # Calculate split
  eth_price     = requests[:eth]['USD']
  btc_price     = requests[:btc]['USD']
  ltc_price     = requests[:ltc]['USD']
  eth_value_usd = (eth_price.to_f * response['eth_received']).round(2)
  btc_value_usd = (btc_price.to_f * response['btc_received']).round(2)
  ltc_value_usd = (ltc_price.to_f * response['ltc_received']).round(2)

  split = [
    {
      value: btc_value_usd,
      color: 'rgb(253, 180, 92)',
      label: 'Bitcoin',
    },
    {
      value: ltc_value_usd,
      color: 'rgb(220, 220, 220)',
      label: 'Litecoin',
    },
    {
      value: eth_value_usd,
      color: 'rgb(151, 187, 205)',
      label: 'Etherium',
    },
  ]

  # Format the data correctly
  data = {
    datasets: [{
      data: split.map {|s| s[:value] },
      backgroundColor: split.map {|s| s[:color] },
    }],
    labels: split.map {|s| s[:label] },
  }
  send_event('split', data: data)

  send_event('presale', current: response['presale'])
  send_event('btc_received', current: response['btc_received'])
  send_event('ltc_received', current: response['ltc_received'])
  send_event('eth_received', current: response['eth_received'])
  send_event('backers', current: response['backers'])
end


SCHEDULER.every '8m' do
  last_x += 1
  points << { x: last_x, y: current_value }
  labels << Time.new.to_i

  # Limit the amount of data
  data_limit = 290
  if points.length > data_limit
    points = points.drop(points.length - data_limit)
  end
  if labels.length > data_limit
    labels = labels.drop(labels.length - data_limit)
  end
  send_event('usd_value', { points: points, labels: labels })
end
