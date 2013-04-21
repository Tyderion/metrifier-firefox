widgets = require("sdk/widget")
tabs = require("sdk/tabs")
self = require("sdk/self")
widget = widgets.Widget(
  id: "mozilla-link"
  label: "Mozilla website"
  contentURL: "http://www.mozilla.org/favicon.ico"
  onClick: ->
   tabs.activeTab.attach
    contentScriptFile: [self.data.url("jquery.min.js"), self.data.url("quantities.js"), self.data.url("content_script.js")]
)



