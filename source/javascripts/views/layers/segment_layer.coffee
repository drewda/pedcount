class Smartphone.Views.SegmentLayer extends Backbone.View
  initialize: ->
    @geojson = @options.geojson
    
    @layer = null
  enable: ->
    if $('#segment-layer').length == 0
      @render()
  disable: ->
    @remove()
  remove: ->
    masterRouter.map.map.removeLayer(@layer) if @layer
  render: ->
    @remove()
    @layer = L.geoJson @geojson,
      style: (feature) ->
        if masterRouter.segments.getByCid(feature.cid).get("selected")
          return { color: '#55ee33', weight: 10, opacity: .8 }
        else
          return { color: '#000000', weight: 10, opacity: .8 }
    @layer.addTo(masterRouter.map.map)
