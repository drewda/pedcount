class Smartphone.Routers.Master extends Backbone.Router
  initialize: (options) ->
    # this is how masterRouter will be referred to from other objects
    window.masterRouter = this

    console.log 'initializing masterRouter'

    # initialize Backbone collections
    @projects = new Smartphone.Collections.Projects
    @users = new Smartphone.Collections.Users
    @segments = new Smartphone.Collections.Segments
    @count_plans = new Smartphone.Collections.CountPlans
    @gate_groups = new Smartphone.Collections.GateGroups
    @gates = new Smartphone.Collections.Gates
    @count_sessions = new Smartphone.Collections.CountSessions

    # timers array (which will be used by EnterCountPage)
    @timers = []

    # set up masterRouter using jQuery Mobile Router Lite plugin:
    # https://github.com/1Marc/jquery-mobile-routerlite
    $.mobile.routerlite.pagechange '#sign-in', (page) ->
      console.log 'signIn route triggered'
      masterRouter.signInPage = new Smartphone.Views.SignInPage

    $.mobile.routerlite.pagechange '#open-project', (page) ->
      console.log 'openProject route triggered'
      hashParams = getHashParams()

      # If we arrived here by way of a Cordova resume,
      # we might not have the current user yet.
      if not masterRouter.users.getCurrentUser()
        $.mobile.showPageLoadingMsg()
        masterRouter.users.fetch
          success: -> 
            $.mobile.hidePageLoadingMsg()
          error: ->
            $.mobile.hidePageLoadingMsg()
            $.mobile.changePage "#sign-in"
            JqmHelpers.flashPopup '#error-loading-users-popup'

      # clear collections for when we switch to another project
      masterRouter.segments.reset()
      masterRouter.count_sessions.reset()
      masterRouter.gates.reset()
      masterRouter.gate_groups.reset()
      masterRouter.count_plans.reset()

      masterRouter.openProjectPage = new Smartphone.Views.OpenProjectPage
      if masterRouter.projects.length == 0
        masterRouter.openProjectPage.reloadProjectsButtonClick()

    $.mobile.routerlite.pagechange '#load-project', (page) ->
      hashParams = getHashParams()
      if masterRouter.reset(hashParams, ['projectId'])
        $.mobile.showPageLoadingMsg()
        masterRouter.segments.fetch
          success: ->
            masterRouter.count_plans.fetch
              success: ->
                masterRouter.count_sessions.fetch
                  success: ->
                    if masterRouter.count_plans.getCurrentCountPlan()
                      # we need to fetch GateGroup's because that's needed for CountPlan.getAllUserIds()
                      # maybe in the future this is a method to move to the server-side
                      masterRouter.gate_groups.fetch
                        success: ->
                          $.mobile.hidePageLoadingMsg()
                          $.mobile.changePage "#show-count-schedule?projectId=#{masterRouter.projects.getCurrentProjectId()}"
                    else
                      # if there is no current count plan for this project, 
                      # send the user back to select a different project
                      $.mobile.hidePageLoadingMsg()
                      $('#no-current-count-plan-error-popup').popup 'open'
                      setTimeout ->
                        $('#no-current-count-plan-error-popup').popup 'close'
                        $.mobile.changePage "#open-project"
                      , 1500

    $.mobile.routerlite.pagechange '#show-count-schedule', (page) ->
      console.log 'showCountSchedule route triggeredddd'
      hashParams = getHashParams()
      if masterRouter.reset(hashParams, ['projectId'])
        masterRouter.showCountSchedulePage = new Smartphone.Views.ShowCountSchedulePage
          model: masterRouter.projects.getCurrentProject()
          # date: hashParams.date if hashParams.date
          # userId: hashParams.userId if hashParams.userId

    $.mobile.routerlite.pagechange '#start-count', (page) ->
      console.log 'startCount route triggered'
      hashParams = getHashParams()
      if masterRouter.reset(hashParams, ['projectId', 'gateId'])
        masterRouter.startCountPage = new Smartphone.Views.StartCountPage
          gate: masterRouter.gates.get(hashParams.gateId)

    $.mobile.routerlite.pagechange '#enter-count', (page) ->
      console.log 'enterCount route triggered'
      hashParams = getHashParams()
      if masterRouter.reset(hashParams, ['projectId', 'countSessionCid'])
        masterRouter.enterCountPage = new Smartphone.Views.EnterCountPage
          countSessionCid: hashParams.countSessionCid

    $.mobile.routerlite.pagechange '#validate-count', (page) ->
      console.log 'validateCount route triggered'
      hashParams = getHashParams()
      if masterRouter.reset(hashParams, ['projectId', 'countSessionCid'])
        masterRouter.validateCountPage = new Smartphone.Views.ValidateCountPage
          countSessionCid: hashParams.countSessionCid

  reset: (hashParams, hashParamsExpected) ->
    # check to make sure each of the expected hash parameters are there
    _.each hashParamsExpected, (hashParam) ->
      # if one is not there, go back to the start
      if not hashParams.hasOwnProperty(hashParam)
        window.location = '/'
        return false
    # if we didn't send the user back to the start, 
    # we can now set the current project ID
    projectId = hashParams.projectId
    masterRouter.projects.setCurrentProjectId projectId
    return true

  clearTimers = ->
    _.each @timers, (t) ->
      clearInterval t
    @timers = []