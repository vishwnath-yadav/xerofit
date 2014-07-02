# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->

    $('.subscrip').click ->
      $(".subscrip").html('<img src="/assets/ajax-loader.gif">');
      if $('#card_number').length
        subscription.processCard()
      else
        true
  
  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, subscription.handleStripeResponse)
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#user_subscriptions_stripe_card_token').val(response.id)
      $('#payment_billing')[0].submit()
    else
      $('#stripe_error').text(response.error.message);
      alert(response.error.message)
      $(".subscrip").html('<a href="javascript:void(0)" class="save_btn save_btn1">Save</a>');