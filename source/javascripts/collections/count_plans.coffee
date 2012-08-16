class Smartphone.Collections.CountPlans extends Backbone.Collection
  model: Smartphone.Models.CountPlan
  url: ->
    Smartphone.Api.construct_url("projects/#{masterRouter.projects.getCurrentProjectId()}/count_plans.json?current=true")
  getCurrentCountPlan: ->
    @detect (cp) => cp.get('is_the_current_plan')
  getCurrentCountPlanId: ->
  	currentCountPlan = @getCurrentCountPlan()
  	if currentCountPlan
  		return currentCountPlan.id
  	else
  		return 0
