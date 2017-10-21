class Dashing.Example extends Dashing.Chartjs
  ready: ->
    @lineChart 'myChart', # The ID of your html element
      ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5"], # Horizontal labels
      [
        label: 'Number of pushups' # Text displayed when hovered
        colorName: 'blue' # Color of data
        data: [10, 39, 20, 49, 87] # Vertical points
      ]
