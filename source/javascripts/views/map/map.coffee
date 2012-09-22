class Smartphone.Views.Map extends Backbone.View
  initialize: ->
    @map = null
    @osmLayer = null

    $('#map-area').empty().append('<div id="map"></div>')

    @render()
  render: ->
    # make the map div fit the screen
    mapContainer = $('#map')
    usedHeight = 0
    usedHeight += $('#start-count .ui-header').outerHeight()
    usedHeight += $('#start-count .ui-bar').outerHeight()
    mapContainer.height($(window).height() - usedHeight)
    @map = L.map 'map',
      attributionControl: false
      zoomControl: false
    @osmLayer = L.tileLayer 'http://otile{s}.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png',
      subdomains: '1234'
    # @map.attributionControl.addAttribution '&copy; OpenStreetMap contributors'
    @osmLayer.addTo(@map)
    @fitProjectBounds()

  fitProjectBounds: ->
    currentProject = masterRouter.projects.getCurrentProject()
    @map.fitBounds [
      [Number(currentProject.get 'southwest_latitude'), Number(currentProject.get 'southwest_longitude')]
      [Number(currentProject.get 'northeast_latitude'), Number(currentProject.get 'northeast_longitude')]
    ]
