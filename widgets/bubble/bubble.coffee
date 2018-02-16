class Dashing.Bubble extends Dashing.Chartjs

  @accessor 'current', ->
    value = @get('value')
    if value
      value

  @accessor 'last-rebalance', ->
    value = @get('last_rebalance')
    if value
      "Last rebalanced " + timeAgo(value) + "ago"

  ready: ->
    @chart = @bubbleChart("bubble",@get('datasets'))
    @chart

  onData: (data) ->
    if @chart
      if data.datasets
        @chart.config.data.datasets = data.datasets
        @chart.update()
