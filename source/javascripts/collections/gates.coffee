class Smartphone.Collections.Gates extends Backbone.Collection
  model: Smartphone.Models.Gate

  initialize: ->
    masterRouter.gate_groups.bind "reset", @fetchIfCurrentCountPlan, this

  url: ->
    Smartphone.Api.construct_url("projects/#{masterRouter.projects.getCurrentProjectId()}/count_plans/#{masterRouter.count_plans.getCurrentCountPlan().id}/gates")

  fetchIfCurrentCountPlan: ->
    @fetch() if masterRouter.count_plans.getCurrentCountPlan()