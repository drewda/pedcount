class Smartphone.Routers.Cordova extends Backbone.Router
  initialize: (options) ->
    # this is how cordovaRouter will be referred to from other objects
    window.cordovaRouter = this

    console.log 'deviceready'
    # bind to Cordova events
    document.removeEventListener "pause", @onCordovaPause, false
    document.removeEventListener "resume", @onCordovaResume, false
    document.addEventListener "pause", @onCordovaPause, false
    document.addEventListener "resume", @onCordovaResume, false

    # run the first time on boot
    @onCordovaResume()

  ###
  # Cordova events
  ###
  onCordovaPause: ->
    console.log 'onCordovaPause'
    currentHash = window.location.hash
    window.localStorage.setItem Smartphone.LocalStorageKeys.previous_hash, currentHash

    # save extra details depending upon the currentHash
    # if currentHash.startsWith '#enter-count'
      # TODO

  onCordovaResume: ->
    console.log 'onCordovaResume'
    previousHash = window.localStorage.getItem Smartphone.LocalStorageKeys.previous_hash
    console.log "The previousHash was #{previousHash}"
    authenticationToken = window.localStorage.getItem Smartphone.LocalStorageKeys.authentication_token
    console.log "authenticationToken: #{authenticationToken}"
    if authenticationToken == "" or authenticationToken == null
      hash = '#sign-in' 
    else
      $.ajaxSetup
        data:
          "auth_token": authenticationToken
      if previousHash.startsWith '#show-count-schedule'
        # if we were previously on a showCountSchedule page, we'll
        # have to reload the entire project
        hash = previousHash.replace('#show-count-schedule', '#load-project')
      else
        hash = '#open-project'    
    console.log "new has will be: #{hash}"
    
    console.log "window.masterRouter exists? #{window.masterRouter?}"
    # If we've already created the MasterRouter on a previous 
    # initialization then we'll just change pages.
    if window.masterRouter?
      $.mobile.changePage hash
    else
      document.location.hash = hash
      window.Smartphone.masterStart()
      $.mobile.initializePage()  
