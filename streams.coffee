WebSocket = require 'ws'
WebSocketServer = WebSocket.Server
log = console.log
API = require './modules/api'
_ = require 'underscore'

wss = new WebSocketServer({ port: 9001 })

wss.on('connection', (ws) ->

  api = API(ws)
  handlerForType = (type) ->
    return api[type]

  hasHandlerForType = (type) ->
    return _.has(api, type)

  parse = (payload) ->
      JSON.parse(payload)

  apiListener = (payload) ->
    message = parse(payload)
    type = message.type

    if hasHandlerForType(type)
      handle = handlerForType(type)
      handle(message)
    else
      handle = handlerForType('error')
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
