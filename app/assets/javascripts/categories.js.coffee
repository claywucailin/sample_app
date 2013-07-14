# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  return true if $("#category_show").length < 1

  $(".left_nav > li").mouseover ->
    $(this).css("background-color", "#A0220B")
    $(this).find(">:first-child").css("color", "white")

  $(".left_nav > li").mouseout ->
    $(this).removeAttr("style")
    $(this).find(">:first-child").removeAttr("style")
