require 'rest-client'
require 'mongo'
require 'json'


requests      = []
points        = []
labels        = []
last_x        = 1
current_value = 0
current_nav   = 0.to_f

# Database Variables
mongo_hostname = ENV['MONGO_HOSTNAME'] || '127.0.0.1'
mongo_port     = ENV['MONGO_PORT']     || '27017'
mongo_database = ENV['MONGO_DATABASE'] || 'main'
Mongo::Logger.logger.level = ::Logger::FATAL
@mongo = Mongo::Client.new([ "#{mongo_hostname}:#{mongo_port}" ], :database => mongo_database)

COLORS = {
  BTC:   "#F7931A",
  BCH:   "#F7931A",
  NEO:   "#4AB507",
  QTUM:  "#2895D8",
  EOS:   "#080809",
  HSR:   "#413176",
  OMG:   "#1536EC",
  ADA:   "#222222",
  ETH:   "#282828",
  LTC:   "#838383",
  XRP:   "#346AA9",
  XMR:   "#FF6600",
  DOGE:  "#BA9F33",
  MAID:  "#5492D6",
  STEEM: "#1A5099",
  XEM:   "#41bf76",
  DGD:   "#D8A24A",
  TIPS:  "#1b78bc",
  DASH:  "#1c75bc",
  LSK:   "#1A6896",
  BTS:   "#03A9E0",
  XLM:   "#03A9F9",
  PPC:   "#3FA30C",
  AMP:   "#048DD2",
  FCT:   "#2175BB",
  YBC:   "#D6C154",
  STRAT: "#2398dd",
  WAVES: "#24aad6",
  ICN:   "#4c6f8c",
  REP:   "#40a2cb",
  ZEC:   "#e5a93d",
  MIOTA: "#b9b9b9",
  ETC:   "#669073",
  NXT:   "#008FBB",
  SIA:   "#00CBA0",
  DAO:   "#FF3B3B",
  BTG:   "#F7931A",
}

def get_stat(stat)
  @mongo[:statistics].find({
    name: stat,
    }).first['value']
end

def holdings
  @mongo[:holdings].find
end

SCHEDULER.every '3s' do
  # Get current value for graph
  current_value = get_stat('usd_value').to_f

  # Send an event to update the number but not the whole graph
  send_event('usd_value', value: current_value)

  # Calculate split
  split = []
  holdings.each do |asset|
    split << {
      value: asset['value'],
      color: COLORS[asset['name'].to_sym],
      label: asset['name']
    }
  end

  # Format the data correctly
  data = {
    datasets: [{
      data: split.map {|s| s[:value] },
      backgroundColor: split.map {|s| s[:color] },
    }],
    labels: split.map {|s| s[:label] },
  }
  send_event('split', data: data)

  # Calculate NAV
  current_nav = get_stat('nav_per_token').to_f

  percent     = ((current_nav - 1) / 1.00) * 100
  # If the percentage is negative, make it positive and set the arrow to down
  if percent < 0
    percent   = percent * -1.0
    direction = 'down'
  else
    direction = 'up'
  end
  send_event('nav', { current: current_nav.round(3), diff: percent.round(2), direction: direction })

  send_event('presale', current: get_stat('presale'))
  send_event('backers', current: get_stat('backers'))
end

# Calculate a new point every 8 mins. But rely on another task to actually send
# the data
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
end

# I can't work out a nice way of providing the data to the clients initally when
# they load the dashobard. For now I'll just put a timer on and re-send the
# whole thing every two seconds. There must be a better way to do this
SCHEDULER.every "2s" do
  send_event('usd_value', { points: points, labels: labels })
end
