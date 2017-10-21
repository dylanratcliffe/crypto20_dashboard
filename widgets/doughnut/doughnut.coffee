class Dashing.Doughnut extends Dashing.Chartjs

  ready: ->
    @chart = @doughnutChart("nut",@get('data'))
    @chart

  onData: (data) ->
    if @chart
      @chart.config.data.datasets = data.data.datasets
      @chart.update()
