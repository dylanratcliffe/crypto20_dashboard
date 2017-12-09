class Dashing.Bubble extends Dashing.Chartjs

  @accessor 'current', ->
    value = @get('value')
    if value
      value


  ready: ->
    @chart = @bubbleChart("bubble")
    @chart

  onData: (data) ->
    if @chart
      if data.datasets
        @chart.config.data.datasets = data.datasets
        @chart.update()
