class Smartphone.Views.ShowCountSchedulePage extends Backbone.View
  initialize: ->
    $('#current_project_name').text masterRouter.projects.getCurrentProject().get('name')

    # TODO: finish
    console.log 'a'
    @date = @options.date
    console.log 'b'
    @userId = masterRouter.users.getCurrentUser().id
    console.log 'c'
    @countPlan = masterRouter.count_plans.getCurrentCountPlan()

    if not @date
      # otherwise select the start or the end of the CountPlan's date range
      today = new XDate()
      startDate = new XDate @countPlan.get('start_date')
      endDate = new XDate @countPlan.get('end_date')
      if today >= startDate and today <= endDate
        @date = today.toString("yyyy-MM-dd")
      else if today < startDate
        @date = startDate.toString("yyyy-MM-dd")
      else
        @date = endDate.toString("yyyy-MM-dd")
      projectId = masterRouter.projects.getCurrentProjectId()
      console.log 'changing the date'
      $.mobile.changePage "#show-count-schedule?projectId=#{projectId}&date=#{@date}"

    @countingScheduleListView = new Smartphone.Views.CountingScheduleListview
      date: @date
      userId: @userId

    # disable the drop-down select bindings that have been turned on
    # when visiting this page previously
    $('#measure-count-day-select').off "change"

    # fill the day drop-down select
    $('#measure-count-day-select').empty()
    _.each @countPlan.getAllDates(), (date) ->
      $('#measure-count-day-select').append "<option value='#{date.toString("yyyy-MM-dd")}'>#{date.toString("ddd d MMM yyyy")}</option>"

    # select the date
    if @date
      # do the actual selection (and don't forget to fresh for jQM)
      $('#measure-count-day-select').val(@date).selectmenu('refresh', true)

    # bindings for the drop-down select
    $('#measure-count-day-select').on "change", $.proxy @measureCountDaySelectChange, this

  destroy: ->
    $('#measure-count-day-select').off "change"

  measureCountDaySelectChange: ->
    date = $('#measure-count-day-select').val()
    projectId = masterRouter.projects.getCurrentProjectId()
    $.mobile.changePage "#show-count-schedule?projectId=#{projectId}&date=#{date}"
