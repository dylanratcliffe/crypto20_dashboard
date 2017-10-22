class Dashing.Line extends Dashing.Chartjs

  @accessor 'current', ->
    value = @get('value')
    if value
      value


  ready: ->
    @chart   = @lineChart("line",@get('points'),@get('labels'))
    @current = @get('value')
    @chart

  onData: (data) ->
    if @chart
      if data.value
        @current = data.value
        @chart.update()
      if data.points
        @chart.config.data.datasets[0].data = data.points
        @chart.config.data.labels = data.labels
        @chart.update()
