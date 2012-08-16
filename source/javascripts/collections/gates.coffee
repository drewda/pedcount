class Smartphone.Collections.Gates extends Backbone.Collection
  model: Smartphone.Models.Gate

  initialize: ->
    masterRouter.gate_groups.on "reset", @fetchIfCurrentCountPlan, this

  url: ->
    Smartphone.Api.construct_url("projects/#{masterRouter.projects.getCurrentProjectId()}/count_plans/#{masterRouter.count_plans.getCurrentCountPlanId()}/gates.json")

  fetchIfCurrentCountPlan: ->
    @fetch() if masterRouter.count_plans.getCurrentCountPlan()