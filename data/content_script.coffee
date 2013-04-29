converted =
  fahrenheit: []
min_celsius = -273.15
prefSet = null

#Maybe Use: http://james.padolsey.com/javascript/find-and-replace-text-with-javascript/

self.port.on "setPrefs", (payload) ->
  prefSet = payload


self.port.on "convert", (payload) ->
  myRe = new RegExp "([0-9]+) (?:#{payload})", "gi"
  str = document.body.innerHTML
  myArray = undefined
  while (myArray = myRe.exec(str)) isnt null
    newRegex = new RegExp("#{myArray[0]}")
    num = parseFloat(myArray[1])
    celsius = (num-32)/1.8
    celsius += min_celsius if (prefSet.prefs.temperature_unit is "kelvin")
    celsius = Number((celsius).toFixed(2))
    newval = celsius+" "+prefSet.prefs.temperature_unit.trim()
    converted.fahrenheit.push
      newval: newval
      oldval: myArray[0]

    str = str.replace newRegex, newval

  document.body.innerHTML = str

self.port.on "undo", (payload) ->
  replaced = document.body.innerHTML
  if payload is "fahrenheit" or payload is "all"
    for undo in converted.fahrenheit
      replaced = replaced.replace undo.newval, undo.oldval


  document.body.innerHTML = replaced
