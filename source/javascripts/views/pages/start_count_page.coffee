class Smartphone.Views.StartCountPage extends Backbone.View
  initialize: ->
    @gate = @options.gate
    $('.header-gate-label-span').text @gate.printLabel()

    # remove any previously registered events
    $('#start-count-yes-button').off()

    $('#start-count-yes-button').on "vclick", $.proxy @startCountYesButtonClick, this

    masterRouter.map = new Smartphone.Views.Map

    # deselect any previous segments and now select the new one
    masterRouter.segments.selectNone()

    @gate.getSegment().select()

    masterRouter.segment_layer = new Smartphone.Views.SegmentLayer
      geojson: masterRouter.segments.geojson().features
    masterRouter.segment_layer.render()
    # TODO: figure out which order to enter the pairs in SW, NE
    # masterRouter.map.map.fitBounds [
    #   [@gate.getSegment().get('start_latitude'), @gate.getSegment().get('start_longitude')]
    #   [@gate.getSegment().get('end_latitude'), @gate.getSegment().get('end_longitude')]
    # ]
    masterRouter.map.map.setView [Number(@gate.getSegment().get('start_latitude')), Number(@gate.getSegment().get('start_longitude'))], 16

  startCountYesButtonClick: ->
    projectId = masterRouter.projects.getCurrentProjectId()

    # create CountSession locally
    countSession = new Smartphone.Models.CountSession
    countSession.set
      user_id: masterRouter.users.getCurrentUser().id
      project_id: projectId
      gate_id: @gate.id
      count_plan_id: masterRouter.count_plans.getCurrentCountPlan().id
      duration_seconds: masterRouter.count_plans.getCurrentCountPlan().get 'count_session_duration_seconds'
    masterRouter.count_sessions.add countSession

    # select this CountSession so that we'll be able 
    # to access from masterRouter.count_sessions.selected()
    countSession.select()

    # advance to EnterCount
    $.mobile.changePage "#enter-count?projectId=#{projectId}&countSessionCid=#{countSession.cid}"