class Smartphone.Routers.CordovaEvents extends Backbone.Router
  initialize: (options) ->
    document.addEventListener "pause", @onPause, false
    document.addEventListener "resume", @onResume, false
  onPause: ->
    window.localStorage.setItem "url-hash", window.location.hash
  onResume: ->
    urlHash = window.localStorage.getItem "url-hash"

    navigator.notification.alert "Hello. I am back! The url-hash was #{urlHash}"
