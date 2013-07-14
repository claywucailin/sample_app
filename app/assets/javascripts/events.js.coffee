# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  return true if $("#event_show").length < 1

  $(".jump_to_page").change ->
    if parseInt($(this).val()) <= parseInt($(".page_count").html())
      href = $(".jump_to_button").attr("url") + "?page=" + $(this).val()
      $(".jump_to_button").attr("href", href)
