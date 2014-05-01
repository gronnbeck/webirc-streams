WebSocket = require 'ws'
WebSocketServer = WebSocket.Server
log = console.log
API = require './modules/api'
Router = require './modules/router'

wss = new WebSocketServer({ port: 9001 })

wss.on('connection', (ws) ->

  api = API(ws)
  route = { login: 'identify' }
  router = Router(api, route)

  parse = (payload) ->
      JSON.parse(payload)

  apiListener = (payload) ->
    message = parse(payload)
    type = message.type

    if router.has(type)
      handle = router.get(type)
      handle(message)
    else
      handle = api.error
      error = { error: 'No handler for type \'' + type  + '\''}
      handle(error)

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
