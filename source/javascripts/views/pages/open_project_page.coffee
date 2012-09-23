class Smartphone.Views.OpenProjectPage extends Backbone.View
  el: '#open-project'
  initialize: ->
    # disable the click bindings that have been turned on
    # when visiting this page previously
    $('#sign-out-button').off "click"
    $('#reload-projects-button').off "click"

    # bindings for buttons
    $('#sign-out-button').on "click", $.proxy @signOutButtonClick, this
    $('#reload-projects-button').on "click", $.proxy @reloadProjectsButtonClick, this

    masterRouter.projects.on 'reset', @renderProjectListview, this
    masterRouter.projects.on 'add', @renderProjectListview, this
    masterRouter.projects.on 'remove', @renderProjectListview, this
    masterRouter.projects.on 'change', @renderProjectListview, this

    masterRouter.users.on 'reset', @render, this # update user name
    @render()

    @renderProjectListview()

  # destroy: ->
  #   $('#sign-out-button').off "click"
  #   $('#reload-projects-button').off "click"
  #   masterRouter.projects.off 'reset'
  #   masterRouter.projects.off 'add'
  #   masterRouter.projects.off 'remove'
  #   masterRouter.projects.off 'change'

  render: ->
    if masterRouter.users.getCurrentUser()
      $('#current_user_name').text masterRouter.users.getCurrentUser().full_name()

  renderProjectListview: ->
    @projectListview = new Smartphone.Views.ProjectListview

  signOutButtonClick: ->
    window.localStorage.removeItem Smartphone.LocalStorageKeys.authentication_token
    $.mobile.changePage "#sign-in"

  reloadProjectsButtonClick: ->
    $.mobile.loading 'show'
    masterRouter.projects.fetch
      success: ->
        $.mobile.loading 'hide'
      error: ->
        $.mobile.loading 'hide'
        JqmHelpers.flashPopup '#projects-fetch-error-popup'
