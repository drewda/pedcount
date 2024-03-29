class Smartphone.Views.EnterCountPage extends Backbone.View
  initialize: ->
    # look up the appropriate CountSession
    @countSession = masterRouter.count_sessions.getByCid @options.countSessionCid

    # initialize the array that will hold timestamps for the counts
    # in the future this may be a few arrays, one for each class of count
    # like male, female, etc.
    @countSessionDates = []

    # update the number of people counted (to zero)
    # in case the currently rendered number is left
    # over from a previous CountSession
    @redrawCounter()

    masterRouter.powerManagement 'dim'

    # set the start time to now
    start = new XDate
    @countSession.set
      start: start.toString()

    # set the end time; this is used by the setTimeout  
    # function to see if the CountSession is over yet
    @endTime = start.addSeconds @countSession.get('duration_seconds')

    # initialize and start the first timer
    @timer = setTimeout @timerFunction, 1000 # run every second

    # display the proper header title
    $('.header-gate-label-span').text @countSession.getGate().printLabel()

    # first remove any previous button bindings
    $('#count-plus-five-button').off()
    $('#count-plus-one-button').off()
    $('#count-minus-one-button').off()
    $('#cancel-counting-button').off()

    # button bindings
    $('#count-plus-five-button').on "click", $.proxy @countPlusFiveButtonClick, this
    $('#count-plus-one-button').on "click", $.proxy @countPlusOneButtonClick, this
    $('#count-minus-one-button').on "click", $.proxy @countMinusOneButtonClick, this
    $('#cancel-counting-button').on "click", $.proxy @cancelCountingButtonClick, this

  timerFunction: ->
    clearInterval masterRouter.enterCountPage.timer
    now = new XDate
    if now > masterRouter.enterCountPage.endTime
      masterRouter.enterCountPage.finish()
    else
      masterRouter.enterCountPage.redrawTimer()
      # run again in another second
      masterRouter.enterCountPage.timer = setTimeout masterRouter.enterCountPage.timerFunction, 1000

  cancelCountingButtonClick: ->
    navigator.notification.confirm 'Are you sure you want to cancel counting?', 
                                   masterRouter.enterCountPage.cancelCountingNotificationClick, 
                                   'Cancel Counting', 
                                   'Yes,No'
  cancelCountingNotificationClick: (buttonIndex) ->
    if buttonIndex == 1
      # cancel the timer
      clearInterval masterRouter.enterCountPage.timer
      # release the power management control
      masterRouter.powerManagement 'release'
      # clear out the data
      masterRouter.enterCountPage.countSessionDates = []
      masterRouter.enterCountPage.endTime = null
      masterRouter.enterCountPage.millisecondsRemaining = null
      # remove the CountSession
      masterRouter.count_sessions.remove @countSession
      # close the dialog
      $('#confirm-cancel-counting-popup').popup 'close'
      # return to ShowCountSchedule
      # ight not tbe necessary to reload the entire project, but for
      # now we'll use this as a way to check off the completed CountSession
      $.mobile.changePage "#load-project?projectId=#{masterRouter.projects.getCurrentProjectId()}"
    else
      return false

  countPlusOneButtonClick: ->
    # add the current datetime to the list
    @countSessionDates.push Date()
    @redrawCounter()
    
  countPlusFiveButtonClick: ->
    for num in [1..5]
      # add the current datetime to the list, five times
      @countSessionDates.push Date() 
    @redrawCounter()
    
  countMinusOneButtonClick: ->
    # remove the last datetime from the list
    @countSessionDates.pop()
    @redrawCounter()

  redrawCounter: ->
    $('#counter-number').text @countSessionDates.length

  redrawTimer: ->
    now = new XDate
    secondsRemaining = now.diffSeconds(masterRouter.enterCountPage.endTime)
    minutes = Math.floor (secondsRemaining / 60)
    seconds = Math.round (secondsRemaining % 60)
    $('#timer #minutes').html "#{minutes} minutes"
    $('#timer #seconds').html "#{seconds} seconds"

  finish: ->
    # get the CountSession
    countSession = masterRouter.count_sessions.selected()[0]

    # set stop time
    stop = new XDate
    countSession.set
      stop: stop.toString()
      status: 'completed'

    # create Count objects
    _.each masterRouter.enterCountPage.countSessionDates, (cdt) ->
      count = new Smartphone.Models.Count
      count.set
        count_session_id: countSession.id
        at: cdt
      countSession.counts.add count

    # clear out the remaining data
    masterRouter.enterCountPage.countSessionDates = []
    masterRouter.enterCountPage.endTime = null
    masterRouter.enterCountPage.millisecondsRemaining = null

    # advance to MeasureTabCountValidate
    projectId = masterRouter.projects.getCurrentProjectId()
    $.mobile.changePage "#validate-count?projectId=#{projectId}&countSessionCid=#{countSession.cid}"
