class Dashing.Doughnut extends Dashing.Chartjs

  ready: ->
    @chart = @doughnutChart("nut",@get('datasets'))
    @chart.options.responsive = true
    @chart

  onData: (data) ->
    if @chart
      @chart.data = data.datasets
      @chart.update()
      @chart.render()
      @chart.reflow()
