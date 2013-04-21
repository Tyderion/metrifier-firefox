console = unsafeWindow.console
console.log
elems = $('*')
myRe = /([0-9]+)[ ]?(?:F|degrees(?: Fahrenheit)?)/g
str = $('body').html()
myArray = undefined
replaced = str
celsius = new Qty("celsius")
while (myArray = myRe.exec(replaced)) isnt null
  console.log myArray
  newRegex = new RegExp("#{myArray[0]}")
  fahrenheit = new Qty "#{myArray[1]} fahrenheit"
  console.log fahrenheit
  replaced = replaced.replace newRegex, fahrenheit.toString("celsius", 2)[..-5]+" °C"
  console.log replaced

$('body').html(replaced)
