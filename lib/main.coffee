widgets = require("sdk/widget")
tabs = require("sdk/tabs")
self = require("sdk/self")
ss = require("sdk/simple-storage")
panels = require("sdk/panel")
prefSet = require("simple-prefs")
contextMenu = require("sdk/context-menu")

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
        contentScriptFile: [self.data.url("jquery.min.js"), self.data.url("content_script.js")]
      tab = tabs.activeTab
      tab.on "ready", ->
        delete save[tab.url]
      save[tabs.activeTab.url] = worker
      worker.port.emit("setPrefs", prefSet)

    if converted
       worker.port.emit("undo", "all")
    else
      worker.port.emit("convert", prefSet.prefs.fahrenheit) if prefSet.prefs.conv_fahrenheit

    converted = not converted

)
menu = contextMenu.Menu(
  label: "Metrifier"
  context: contextMenu.SelectionContext()
)
itm = contextMenu.Item(
  label: "Add to Fahrenheit Strings"
  context: contextMenu.SelectionContext()
  contentScriptFile: self.data.url('rightclick.js')
  onMessage: (text)->
    prefSet.prefs.fahrenheit += "|#{text}"
)

menu.addItem(itm)



