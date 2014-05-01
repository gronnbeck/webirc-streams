db = require './db'
_ = require 'underscore'

API = (ws) ->

  send = (message) ->
    payload = JSON.stringify(message)
    ws.send(payload)

  sendPayload = (payload) ->
    ws.send(payload)

  api =
    identify: (message) ->
      db.user.auth(message.id, message.hash, (err, user) ->
        send(_.extend(message, { success: true }))
        send(user)
      )
    error: (error) ->
      send(_.extend(error, { success: false, type: 'error' }))

  return api


module.exports = API
