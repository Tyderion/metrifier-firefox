self.on "click", ->
  self.postMessage
  window.getSelection().toString()
