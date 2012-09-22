class Smartphone.Routers.Master extends Backbone.Router
  initialize: (options) ->
    # set up masterRouter 
    # using jQuery Mobile Router plugin: https://github.com/azicchetti/jquerymobile-router
    window.masterRouter = new $.mobile.Router [
      { "#sign-in": { events: "i,c,s", handler: "signIn" } }
      { "#open-project": { events: "i,c,s", handler: "openProject" } }
      { "#load-project": { events: "s", handler: "loadProject" } }
      { '#show-count-schedule(?:[?](.*))?': { events: "s,h", handler: "showCountSchedule" } }
      { "#start-count(?:[?](.*))?": { events: "s", handler: "startCount" } }
      { "#enter-count(?:[?](.*))?": { events: "s", handler: "enterCount" } }
      { "#validate-count(?:[?](.*))?": { events: "s", handler: "validateCount" } }
      ], 
        signIn: (eventType, matchObj, ui, page, evt) =>
          console.log "signIn route: #{eventType}"
          if _.include ['pageshow'], eventType
            masterRouter.signInPage = new Smartphone.Views.SignInPage
          # else if eventType == 'pagehide'
          #   masterRouter.signInPage.destroy()

        openProject: (eventType, matchObj, ui, page, evt) =>
          console.log "openProject route: #{eventType}"
          if _.include ['pageshow'], eventType
            hashParams = getHashParams()
            if masterRouter.reset(hashParams, [])
              # clear collections for when we switch to another project
              masterRouter.segments.reset()
              masterRouter.count_sessions.reset()
              masterRouter.gates.reset()
              masterRouter.gate_groups.reset()
              masterRouter.count_plans.reset()
              masterRouter.projects.currentProjectId = 0

              masterRouter.openProjectPage = new Smartphone.Views.OpenProjectPage
          # else if eventType == 'pagehide'
          #   masterRouter.openProjectPage.destroy()

        loadProject: (eventType, matchObj, ui, page, evt) =>
          console.log "loadProject -- route: #{eventType} -- hash: #{window.location.hash}"
          if eventType == 'pageshow'
            hashParams = getHashParams()
            if masterRouter.reset(hashParams, ['projectId'])
              $.mobile.showPageLoadingMsg()
              masterRouter.segments.fetch
                success: ->
                  masterRouter.count_plans.fetch
                    success: ->
                      if masterRouter.count_plans.getCurrentCountPlan()
                        # we need to fetch GateGroup's because that's needed for CountPlan.getAllUserIds()
                        # maybe in the future this is a method to move to the server-side
                        masterRouter.gate_groups.fetch
                          success: ->
                            masterRouter.count_sessions.fetch
                              success: ->
                                $.mobile.hidePageLoadingMsg()
                                if hashParams.date
                                  # if a Cordova onResume is bring us back through here, it may specify a date and user id
                                  $.mobile.changePage "#show-count-schedule?projectId=#{masterRouter.projects.getCurrentProjectId()}&date=#{hashParams.date}"
                                else
                                  # the normal flow just specifies the project
                                  $.mobile.changePage "#show-count-schedule?projectId=#{masterRouter.projects.getCurrentProjectId()}"
                              error: -> masterRouter.errorLoadingProjectPopup()
                          error: -> masterRouter.errorLoadingProjectPopup()
                      else
                        # if there is no current count plan for this project, 
                        # send the user back to select a different project
                        $.mobile.hidePageLoadingMsg()
                        JqmHelpers.flashPopupAndChangePage '#no-current-count-plan-error-popup', "#open-project"
                    error: -> masterRouter.errorLoadingProjectPopup()
                error: -> masterRouter.errorLoadingProjectPopup()
        
        showCountSchedule: (eventType, matchObj, ui, page, evt) =>
          console.log "#{window.location.hash} -- #{eventType}"
          if _.include ['pageshow'], eventType
            console.log 'showCountSchedule route triggeredddd'
            hashParams = getHashParams()
            console.log '1'
            if masterRouter.reset(hashParams, ['projectId'])
              console.log '2'
              masterRouter.showCountSchedulePage = new Smartphone.Views.ShowCountSchedulePage
                model: masterRouter.projects.getCurrentProject()
                date: hashParams.date if hashParams.date
                # userId: hashParams.userId if hashParams.userId
          # else if eventType == 'pagehide'
          #   console.log 'showCountSchedule route hidding'
          #   masterRouter.showCountSchedulePage.destroy()

        startCount: (eventType, matchObj, ui, page, evt) =>
          hashParams = getHashParams()
          if masterRouter.reset(hashParams, ['projectId', 'gateId'])
            masterRouter.startCountPage = new Smartphone.Views.StartCountPage
              gate: masterRouter.gates.get(hashParams.gateId)

        enterCount: (eventType, matchObj, ui, page, evt) =>
          hashParams = getHashParams()
          if masterRouter.reset(hashParams, ['projectId', 'countSessionCid'])
            masterRouter.enterCountPage = new Smartphone.Views.EnterCountPage
              countSessionCid: hashParams.countSessionCid

        validateCount: (eventType, matchObj, ui, page, evt) =>
          hashParams = getHashParams()
          if masterRouter.reset(hashParams, ['projectId', 'countSessionCid'])
            masterRouter.validateCountPage = new Smartphone.Views.ValidateCountPage
              countSessionCid: hashParams.countSessionCid
      , 
        ajaxApp: true

    # initialize Backbone collections
    masterRouter.projects = new Smartphone.Collections.Projects
    masterRouter.users = new Smartphone.Collections.Users
    masterRouter.segments = new Smartphone.Collections.Segments
    masterRouter.count_plans = new Smartphone.Collections.CountPlans
    masterRouter.gate_groups = new Smartphone.Collections.GateGroups
    masterRouter.gates = new Smartphone.Collections.Gates
    masterRouter.count_sessions = new Smartphone.Collections.CountSessions

    # timers array (which will be used by EnterCountPage)
    masterRouter.timers = []

    masterRouter.clearTimers = ->
      _.each @timers, (t) ->
        clearInterval t
      @timers = []

    masterRouter.errorLoadingProjectPopup = ->
      $.mobile.hidePageLoadingMsg()
      JqmHelpers.flashPopupAndChangePage '#error-loading-project-popup', "#open-project"

    masterRouter.reset = (hashParams, hashParamsExpected) ->
      # check to make sure each of the expected hash parameters are there
      _.each hashParamsExpected, (hashParam) ->
        # if one is not there, go back to select a new project
        if not hashParams.hasOwnProperty(hashParam)
          $.mobile.changePage '#open-project'
          return false
      
      # make sure we have users
      if not masterRouter.users.getCurrentUser()
        $.mobile.showPageLoadingMsg()
        masterRouter.users.fetch
          success: -> 
            $.mobile.hidePageLoadingMsg()
          error: ->
            $.mobile.hidePageLoadingMsg()
            $.mobile.changePage "#sign-in"
            JqmHelpers.flashPopup '#error-loading-users-popup'

      # make sure we have projects
      if masterRouter.projects.length == 0
        $.mobile.showPageLoadingMsg()
        masterRouter.projects.fetch
          success: ->
            $.mobile.hidePageLoadingMsg()
            # we can now set the current project ID
            if hashParams.projectId
              projectId = hashParams.projectId
              masterRouter.projects.setCurrentProjectId projectId
            return true
          error: ->
            $.mobile.hidePageLoadingMsg()
            $.mobile.changePage '#sign-in'
            JqmHelpers.flashPopup '#error-communicating-with-server-popup'
            return false
      else
        # we can now set the current project ID
        if hashParams.projectId
          projectId = hashParams.projectId
          masterRouter.projects.setCurrentProjectId projectId
        return true

    masterRouter.powerManagement = (newStatus) ->
      if newStatus == 'release'
        # no longer keep device from going to sleep
        cordova.require('cordova/plugin/powermanagement').release(
          -> console.log 'PowerManagement release: success'
          -> console.log 'PowerManagement release: error'
        )
      else if newStatus == 'dim'
        # keep device from going to sleep
        # iOS: set idleTimerDisabled
        # Android: set SCREEN_DIM_WAKE_LOCK
        cordova.require('cordova/plugin/powermanagement').dim(
          -> console.log 'PowerManagement dim: success'
          -> console.log 'PowerManagement dim: error'
        )
