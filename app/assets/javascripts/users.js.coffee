# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  addListenerToOperations = (selector)->
    allOpList = $(selector)
    allOpList.click (event)->
      event.preventDefault()
      allOpList.each (i)->
        $(allOpList[i]).parent().toggleClass "inactive active"

  addListenerToOrdersManage = ->
    addListenerToOperations(".manage-orders-operations a")
  addListenerToRecommendContainer= ->
    addListenerToOperations(".left-title-bar a")

  addListenerToOrdersManage()
  addListenerToRecommendContainer()
)
