class Dashing.Chartjs extends Dashing.Widget

  doughnutChart: (id, data) ->
    config = {
      type: 'doughnut',
      data: data,
      options: {
        responsive: true,
        legend: {
          display: false,
        }
        animation: {
          animateScale: false,
          animateRotate: false
        },
        tooltips: {
          callbacks: {
            label: `function (t,e) {
              return (e.labels[t.index] + ": " + e.datasets[t.datasetIndex].data[t.index].toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,').replace(/(^-?)/,'$1\$'))}`
          }
        }
      }
    }
    new Chart(document.getElementById(id).getContext("2d"), config)

  bubbleChart: (id) ->
    config = {
      type: 'bubble',
      data: {
        datasets: [],
      },
      options: {
        responsive: true,
        # legend: {
        #   display: false,
        # },
        animation: {
          duration: 0,
        },
        # title:{
        #   display: false,
        #   text:'$USD Value'
        # },
        # tooltips: {
        #   mode: 'index',
        #   intersect: false,
        # },
        # hover: {
        #   mode: 'nearest',
        #   intersect: true
        # },
        legend: {
          display: false,
        },
        tooltips: {
          callbacks: {
            label: `function (t,e) {
              var n=e.datasets[t.datasetIndex].label||"",i=e.datasets[t.datasetIndex].data[t.index];
              return n+": "+(e.datasets[t.datasetIndex].dollarGrowth).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,').replace(/(^-?)/,'$1\$')}`
          }
        },
        scales: {
          xAxes: [{
            display: true,
            labelString: '% of Fund',
            fontColor: '#ffffff',
            ticks: {
              fontColor: "rgba(255,255,255,0.6)",
              callback: `function(value, index, values) {
                return value + '%';
              }`
            }
          }],
          yAxes: [{
            display: true,
            labelString: '% Growth',
            fontColor: '#ffffff',
            ticks: {
              fontColor: "rgba(255,255,255,0.6)",
              callback: `function(value, index, values) {
                return value + '%';
              }`
            }
          }]
        }
      }
    }
    new Chart(document.getElementById(id).getContext("2d"), config)

  lineChart: (id, data, labels) ->
    config = {
      type: 'line',
      data: {
        labels: labels
        datasets: [{
          data: data,
          backgroundColor: 'rgba(255,255,255,0.5)',
          borderColor: 'rgba(255,255,255,1)',
          pointRadius: 0,
        }],
      },
      fill: true,
      options: {
        responsive: true,
        legend: {
          display: false,
        },
        animation: {
          duration: 0,
        },
        title:{
          display: false,
          text:'$USD Value'
        },
        tooltips: {
          mode: 'index',
          intersect: false,
        },
        hover: {
          mode: 'nearest',
          intersect: true
        },
        scales: {
          xAxes: [{
            display: false,
          }],
          yAxes: [{
            display: false,
            scaleLabel: {
              display: true,
              labelString: '$USD'
            }
          }]
        }
      }
    }
    new Chart(document.getElementById(id).getContext("2d"), config)


  merge: (xs...) =>
    if xs?.length > 0
      @tap {}, (m) -> m[k] = v for k, v of x for x in xs

  tap: (o, fn) -> fn(o); o

  colorCode: ->
    blue: "151, 187, 205"
    cyan:  "0, 255, 255"
    darkgray: "77, 83, 96"
    gray: "148, 159, 177"
    green: "70, 191, 189"
    lightgray: "220, 220, 220"
    magenta: "255, 0, 255"
    red: "247, 70, 74"
    yellow: "253, 180, 92"

  color: (colorName) ->
    fillColor: "rgba(#{ @colorCode()[colorName] }, 0.2)"
    strokeColor: "rgba(#{ @colorCode()[colorName] }, 1)"
    pointColor: "rgba(#{ @colorCode()[colorName] }, 1)"
    pointStrokeColor: "#fff"
    pointHighlightFill: "#fff"
    pointHighlightStroke: "rgba(#{ @colorCode()['blue'] },0.8)"

  circleColor: (colorName) ->
    color: "rgba(#{ @colorCode()[colorName] }, 1)"
    highlight: "rgba(#{ @colorCode()[colorName] }, 0.8)"
