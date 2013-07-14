# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#ship_next_step').click (e) =>
    e.preventDefault()
    $ship = $('#ship .content')
    $payment = $('#payment .content')
    $info = $('#confirm .info')

    $info.find('.name').append($('#buyer_name').val())
    $info.find('.addr').append($('#buyer_address').val())
    $info.find('.email').append($('#buyer_email').val())
    $info.find('.tel').append($('#buyer_tel').val())

    $ship.hide()
    $payment.show()

  $('#payment_next_step').click (e) =>
    e.preventDefault()
    $payment = $('#payment .content')
    $info = $('#confirm .info')
    $submit = $('#confirm #submit')

    $info.find('.pay_type').append($("input:radio[name='order[payment_method]']:checked").next().text())
    $info.find('.card_num').append($('#card_num').val())

    $payment.hide()
    $info.show()
    $submit.show()

