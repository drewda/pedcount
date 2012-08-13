class Smartphone.Collections.CountPlans extends Backbone.Collection
  model: Smartphone.Models.CountPlan
  url: ->
    Smartphone.Api.construct_url("projects/#{masterRouter.projects.getCurrentProjectId()}/count_plans?current=true")
  getCurrentCountPlan: ->
    @detect (cp) => cp.get('is_the_current_plan')