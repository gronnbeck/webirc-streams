WebSocket = require 'ws'
WebSocketServer = WebSocket.Server
log = console.log
API = require './modules/api'

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
