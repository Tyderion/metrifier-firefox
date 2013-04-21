console = unsafeWindow.console

converted =
  fahrenheit: []

min_celsius = -273.15


prefSet = null

self.port.on "setPrefs", (payload) ->
  prefSet = payload
  console.log "converting to", prefSet.prefs.temperature_to


self.port.on "convert", (payload) ->
  # console.log payload
  console.log "Converting"
  # payload = payload.replace(new RegExp(" ?, ?","g"), "|")
  elems = $('*')
  # console.log "([0-9]+) (?:#{payload})", "gi"
  myRe = new RegExp "([0-9]+) (?:#{payload})", "gi"
  console.log "converting to", prefSet.prefs.temperature_to
  str = $('body').html()
  myArray = undefined
  replaced = str
  while (myArray = myRe.exec(replaced)) isnt null
    # console.log myArray.index
    newRegex = new RegExp("#{myArray[0]}")
    num = parseFloat(myArray[1])
    celsius = (num-32)/1.8
    celsius += min_celsius if (prefSet.prefs.temperature_unit is "kelvin")
    celsius = Number((celsius).toFixed(2))
    # fahrenheit = new Qty "#{myArray[1]} fahrenheit"
    # newval = fahrenheit.toString(prefSet.prefs.temperature_to, 2)[..-5].trim()+" "+prefSet.prefs.temperature_unit.trim()
    newval = celsius+" "+prefSet.prefs.temperature_unit.trim()
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

