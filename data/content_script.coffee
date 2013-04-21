console = unsafeWindow.console

converted =
  fahrenheit: []


prefSet = null


self.port.on "setPrefs", (payload) ->
  prefSet = payload
  console.log prefSet.prefs


self.port.on "convert", (payload) ->
  # console.log payload
  console.log "Converting"
  # payload = payload.replace(new RegExp(" ?, ?","g"), "|")
  elems = $('*')
  # console.log "([0-9]+) (?:#{payload})", "gi"
  myRe = new RegExp "([0-9]+) (?:#{payload})", "gi"
  console.log myRe
  str = $('body').html()
  myArray = undefined
  replaced = str
  celsius = new Qty("celsius")
  while (myArray = myRe.exec(replaced)) isnt null
    # console.log myArray.index
    newRegex = new RegExp("#{myArray[0]}")
    fahrenheit = new Qty "#{myArray[1]} fahrenheit"
    newval = fahrenheit.toString(prefSet.prefs.temperature_to, 2)[..-5].trim()+" "+prefSet.prefs.temperature_unit.trim()
    console.log newval
    converted.fahrenheit.push
      newval: newval
      oldval: myArray[0]

    replaced = replaced.replace newRegex, newval
  # console.log converted

  $('body').html(replaced)

self.port.on "undo", (payload) ->
  console.log "Undoing",  payload is "all"
  replaced = $('body').html()
  if payload is "fahrenheit" or payload is "all"
    for undo in converted.fahrenheit
      reg = new RegExp "#{undo.newval}"
      replaced = replaced.replace undo.newval, undo.oldval


  $('body').html(replaced)


self.port.on "log", (payload) ->
  console.log payload

