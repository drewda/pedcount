#= require_self
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

window.Smartphone =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Api:
    protocol: 'http'
    host: 'pedplus.s3sol.com'
    version: 'api'
    construct_url: (url) ->
      url = '/' + url if url[0] != '/'
      Smartphone.Api.protocol + '://' + Smartphone.Api.host + '/' + Smartphone.Api.version + url
  init: ->
    new Smartphone.Routers.CordovaEvents
    new Smartphone.Routers.Master

document.addEventListener "deviceready", window.Smartphone.init, false
