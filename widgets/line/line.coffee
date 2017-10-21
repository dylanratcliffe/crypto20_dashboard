class Dashing.Line extends Dashing.Chartjs

  ready: ->
    @chart = @lineChart("line",@get('points'),@get('labels'))
    @chart

  onData: (data) ->
    if @chart
      @chart.config.data.datasets[0].data = data.points
      @chart.config.data.labels = data.labels
      @chart.update()
