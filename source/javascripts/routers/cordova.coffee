class Smartphone.Routers.Cordova extends Backbone.Router
  initialize: (options) ->
    # this is how cordovaRouter will be referred to from other objects
    window.cordovaRouter = this

    console.log 'deviceready'
    # bind to Cordova events
    document.addEventListener "pause", @onCordovaPause, false
    document.addEventListener "resume", @onCordovaResume, false

    previousHash = window.localStorage.getItem Smartphone.LocalStorageKeys.previous_hash
    console.log "The previousHash was #{previousHash}"
    if @checkAndPrepAuthenticationToken()
      @setJqmStartPageAndInitialize '#open-project'
      # TODO: continue
    else
      @setJqmStartPageAndInitialize '#sign-in'

  ###
  # Cordova events
  ###
  onCordovaPause: ->
    console.log 'onCordovaPause'
    currentHash = window.location.hash
    window.localStorage.setItem Smartphone.LocalStorageKeys.previous_hash, currentHash

    # TODO: save extra details depending upon the currentHash
    # switch currentHash
    # when ''
    # else

  onCordovaResume: ->
    console.log 'onCordovaResume'

  ###
  # helper methods
  ###
  checkAndPrepAuthenticationToken: ->
    authenticationToken = window.localStorage.getItem Smartphone.LocalStorageKeys.authentication_token
    if authenticationToken == "" or authenticationToken == null
      return false 
    else
      $.ajaxSetup
        data:
          "auth_token": authenticationToken
      return true

  setJqmStartPageAndInitialize: (hash) ->
    console.log "setJqmStartPageAndInitialize: #{hash}"
    document.location.hash = hash
    window.Smartphone.masterStart()
    $.mobile.initializePage()
