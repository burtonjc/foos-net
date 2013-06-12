define [
  'underscore'
  'models/membership'

], (_, Membership) ->

  query: (request, response, next) ->
    Membership
      .find(league: request.params.id)
      .lean()
      .exec (err, memberships) ->
        response.json memberships
