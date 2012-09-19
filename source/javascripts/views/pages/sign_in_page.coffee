class Smartphone.Views.SignInPage extends Backbone.View
  el: '#sign-in'
  initialize: ->
    # disable the click bindings that have been turned on
    # when visiting this page previously
    $('#sign-in-button').off "click"

    # bindings for the sign-in button
    $('#sign-in-button').on "click", $.proxy @signInButtonClick, this

  # destroy: ->
  #   $('#sign-in-button').off "click"
    
  signInButtonClick: ->
    email = $('#email').val()
    password = $('#password').val()

    if email == "" or password == ""
      @signInError()
    else
      $.mobile.showPageLoadingMsg()
      $.ajax 
        type: 'post'
        # contentType: 'application/json; charset=utf-8'
        # dataType: 'json'
        url: Smartphone.Api.construct_url('tokens.json')
        data:
          email: encodeURI(email)
          password: encodeURI(password)
        success: @signInSuccess
        error: @signInError

  signInSuccess: (data) ->
    console.log "sign in success: #{data.token}"
    if data.token != null
      window.localStorage.setItem Smartphone.LocalStorageKeys.authentication_token, data.token
      $.ajaxSetup
        data:
          "auth_token": data.token
      masterRouter.users.fetch
        success: -> 
          $.mobile.hidePageLoadingMsg()
          $.mobile.changePage "#open-project"
        error: ->
          $.mobile.hidePageLoadingMsg()
          JqmHelpers.flashPopup '#error-loading-users-popup'
    else
      @signInError()

  signInError: ->
    $.mobile.hidePageLoadingMsg()
    console.log 'sign in error'
    JqmHelpers.flashPopup '#sign-in-error-popup'
