WebSocket = require 'ws'
WebSocketServer = WebSocket.Server
_ = require 'underscore'
log = console.log
db = require './modules/db'

wss = new WebSocketServer({ port: 9001 })

wss.on('connection', (ws) ->

  send = (message) ->
    payload = JSON.stringify(message)
    ws.send(payload)

  sendPayload = (payload) ->
    ws.send(payload)

  parse = (payload) ->
      JSON.parse(payload)

  apiListener = (payload) ->
    message = parse(payload)

    if message.type == 'identify'
      db.user.auth(message.id, message.hash, (err, user) ->
        send(_.extend(message, { success: true }))
        send(user)
      )

  listeners =
    open: () ->
      log('Connection opened')
    message: apiListener
    close: () ->
      log('connection closed')

  ['open', 'message', 'close'].forEach((event) ->
    listener = listeners[event]
    ws.on( event, listener ))

)
