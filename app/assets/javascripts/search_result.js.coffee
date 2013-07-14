# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
window.onload = ->
  $('input[type="radio"],.precise-search label').bind "click", (event)->
    toggleRadioChecked(this)

toggleRadioChecked = ($currentObj) ->
  $currentObj = $($currentObj)
  if $currentObj.context.nodeName == "LABEL"
    $label = $currentObj
    $radio = $("input",$currentObj.siblings())
  else
    $radio = $currentObj
    $label = $("label",$currentObj.siblings())
  if isRadioChecked($label)
    uncheckRadio($label, $radio)
  else
    checkRadio($label, $radio)

isRadioChecked = ($ele) ->
  $ele.hasClass("radio-checked")

uncheckRadio = ($label, $radio) ->
  $($radio).css("display","inline")
  $label.removeClass "radio-checked"

checkRadio = ($label, $radio) ->
  $($radio).css("display","none")
  $label.addClass "radio-checked"

window.onload = ->
  $('.left-side input[type="radio"]').bind "click", (event)->
    $('.left-side form').submit();  
