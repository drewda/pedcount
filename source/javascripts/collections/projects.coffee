class Smartphone.Collections.Projects extends Backbone.Collection
  initialize: ->
    @currentProjectId = 0
  model: Smartphone.Models.Project
  url: ->
    Smartphone.Api.construct_url("projects.json")
  setCurrentProjectId: (projectId) ->
    @currentProjectId = projectId
  getCurrentProjectId: ->
    return @currentProjectId
  getCurrentProject: ->
    @get(@currentProjectId) if @currentProjectId > 0