class Smartphone.Routers.Jqm extends Backbone.Router
  initialize: (options) ->
    # this is how jqmRouter will be referred to from other objects
    window.jqmRouter = this
    
    console.log 'onJqmMobileInit'
    
    # Don't auto initialize, because we'll set our hash depending 
    # upon which page we want the user to start with. After doing
    # that, we'll tell JQM to initialize the page.
    $.mobile.autoInitializePage = false
