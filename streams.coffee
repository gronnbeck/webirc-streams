WebSocket = require 'ws'
WebSocketServer = WebSocket.Server
_ = require 'underscore'
log = console.log

errors =
  alreadyIdentified:
    success: false
    error: 'This socket has already been identified.'

wss = new WebSocketServer({ port: 9001 })

wss.on('connection', (ws) ->

  send = (message) ->
    payload = JSON.stringify(message)
    ws.send(payload)

  sendPayload = (payload) ->
    ws.send(payload)

  parse = (payload) ->
      JSON.parse(payload)

  identifyListener = (payload) ->
    message = parse(payload)

    if message.type == 'identify'
      ws.removeListener('message', identifyListener)
      ws.on('message', setupApi)

      send(_.extend(message, { success: true }))

  setupApi = (payload) ->
    message = parse(payload)
    log(message)
    if message.type == 'identify'
      send(errors.alreadyIdentified)

  listeners =
    open: () ->
      log('Connection opened')
    message: identifyListener
    close: () ->
      log('connection closed')

  ['open', 'message', 'close'].forEach((event) ->
    listener = listeners[event]
    ws.on( event, listener ))

)
