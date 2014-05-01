WebSocket = require 'ws'
WebSocketServer = WebSocket.Server
_ = require 'underscore'
log = console.log
db = require './modules/db'

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

  return api


wss = new WebSocketServer({ port: 9001 })

wss.on('connection', (ws) ->

  api = API(ws)
  handlerForType = (type) ->
    return api[type]

  parse = (payload) ->
      JSON.parse(payload)

  apiListener = (payload) ->
    message = parse(payload)

    handle = handlerForType(message.type)
    handle(message)


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
