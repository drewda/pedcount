class Smartphone.Views.ShowCountSchedulePage extends Backbone.View
  initialize: ->
    $('#current_project_name').text masterRouter.projects.getCurrentProject().get('name')

    @date = @options.date
    @userId = masterRouter.users.getCurrentUser().id
    @countPlan = masterRouter.count_plans.getCurrentCountPlan()

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
      # do the actual selection (and don't forget to refresh for jQM)
      $('#measure-count-day-select').val(@date).selectmenu('refresh', true)

    # bindings for the drop-down select
    $('#measure-count-day-select').on "change", $.proxy @measureCountDaySelectChange, this

  destroy: ->
    $('#measure-count-day-select').off "change"

  measureCountDaySelectChange: ->
    date = $('#measure-count-day-select').val()
    projectId = masterRouter.projects.getCurrentProjectId()
    $.mobile.changePage "#show-count-schedule?projectId=#{projectId}&date=#{date}"
