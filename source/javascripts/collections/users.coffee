class Smartphone.Collections.Users extends Backbone.Collection
  model: Smartphone.Models.User
  url: ->
  	Smartphone.Api.construct_url("users")
  getCurrentUser: ->
    @find (u) =>
      u.get 'is_current_user'