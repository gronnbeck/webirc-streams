_ = require 'underscore'

module.exports = (api, routes) ->
  routes = routes || {}

  handler =
    get: (type) ->
      if _.has(routes, type)
        route = routes[type]
        return api[route]
      else
        return api[type]

    has: (type) ->
      route = routes[type]
      if route == null or route == undefined
        return _.has(api, type)
      else
        return _.has(api, route)
