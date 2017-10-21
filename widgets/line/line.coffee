class Dashing.Line extends Dashing.Chartjs

  @accessor 'current', ->
    points = @get('points')
    if points
      points[points.length - 1].y

  ready: ->
    @chart = @lineChart("line",@get('points'),@get('labels'))
    @chart

  onData: (data) ->
    if @chart
      @chart.config.data.datasets[0].data = data.points
      @chart.config.data.labels = data.labels
      @chart.update()
