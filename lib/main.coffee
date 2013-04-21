widgets = require("sdk/widget")
tabs = require("sdk/tabs")
self = require("sdk/self")
ss = require("sdk/simple-storage")
panels = require("sdk/panel")
prefSet = require("simple-prefs")
# store = ss.storage
# defaults =
#   temperature:
#     fahrenheit:
#       name: "fahrenheit"
#       base: "([0-9]+)"
#       regexes:
#         [
#           "°?F",
#           "degrees",
#           "degrees fahrenheit"
#         ]
#     celsius:
#       name: "celsius"
#       base: "([0-9]+)"
#       regexes:
#         [
#           "°?C",
#           "degrees celsius"
#         ]

# store = defaults

converted = false

save = {}

if prefSet.prefs.temperature_unit is ""
  prefSet.prefs.temperature_unit = "°C"

widget = widgets.Widget(
  id: "metrify-button"
  label: "Metrify this Homepage"
  content: "M"
  onClick: ->
    worker = null
    if save[tabs.activeTab.url]
      worker = save[tabs.activeTab.url]
    else
      worker = tabs.activeTab.attach
        contentScriptFile: [self.data.url("jquery.min.js"), self.data.url("quantities.js"), self.data.url("content_script.js")]
      tab = tabs.activeTab
      console.log worker
      tab.on "ready", ->
        console.log "Deactivated converted tab"
        delete save[tab.url]
      save[tabs.activeTab.url] = worker
      worker.port.emit("setPrefs", prefSet)

    if converted
       worker.port.emit("undo", "all")
    else
      worker.port.emit("convert", prefSet.prefs.fahrenheit) if prefSet.prefs.conv_fahrenheit
      worker.port.emit("convert", prefSet.prefs.fahrenheit) if prefSet.prefs.conv_fahrenheit

    converted = not converted



)

# port.on "save_Converted", (payload) ->
#   save[payload.name] = payload.content


# port.on "updateSettings", (payload) ->
#   store = payload

# port.on "getSettings", (payload) ->



