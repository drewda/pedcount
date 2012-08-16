#= require libraries/jquery
#= require libraries/json2
#= require libraries/underscore
#= require libraries/underscore-addons
#= require libraries/backbone
#= require libraries/backbone-modelbinder
#= require libraries/polymaps
#= require libraries/xdate
#= require libraries/starts-with
#= require libraries/get-hash-params
#= require_self
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers
#= require libraries/jquery-mobile
#= require libraries/jquery-mobile-routerlite
#= require libraries/jquery-mobile-simpledialog
#= require libraries/jquery-mobile-helpers

window.Smartphone =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Api:
    protocol: 'http'
    host: 'localhost:3000'
    version: 'api'
    construct_url: (url) ->
      url = '/' + url if url[0] != '/'
      Smartphone.Api.protocol + '://' + Smartphone.Api.host + '/' + Smartphone.Api.version + url
  LocalStorageKeys:
    authentication_token: 'authentication-token'
    previous_hash: 'previous-hash'
  mobileinit: ->
    new Smartphone.Routers.Jqm
  deviceready: ->
    new Smartphone.Routers.Cordova
  masterStart: ->
    new Smartphone.Routers.Master

$(document).bind "mobileinit", window.Smartphone.mobileinit

document.addEventListener "deviceready", window.Smartphone.deviceready, false
