class Smartphone.Views.ProjectListview extends Backbone.View
  initialize: ->
    @render()
  render: ->
    $('#project-listview').empty()

    masterRouter.projects.each (project) ->
      $('#project-listview').append "<li><a href='#load-project?projectId=#{project.id}'>#{project.get('name')}</a></li>"

    $('#project-listview').listview('refresh')
