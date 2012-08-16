class Smartphone.Collections.Segments extends Backbone.Collection
  model: Smartphone.Models.Segment
  url: ->
    Smartphone.Api.construct_url("projects/#{masterRouter.projects.getCurrentProjectId()}/segments.json")
  geojson: ->
    geojson =
      type: 'FeatureCollection'
      features: _.compact @map (s) -> s.geojson()