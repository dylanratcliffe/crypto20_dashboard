class Dashing.Nav extends Dashing.Widget
  @accessor 'current', Dashing.AnimatedValue

  @accessor 'difference', ->
    diff = @get('diff')
    if diff
      "#{diff}%"
    else
      "???"

  @accessor 'arrow', ->
    direction = @get('direction')
    if direction
      if direction == "up" then 'fa fa-arrow-up' else 'fa fa-arrow-down'

  onData: (data) ->
    if data.status
      # clear existing "status-*" classes
      $(@get('node')).attr 'class', (i,c) ->
        c.replace /\bstatus-\S+/g, ''
      # add new class
      $(@get('node')).addClass "status-#{data.status}"
