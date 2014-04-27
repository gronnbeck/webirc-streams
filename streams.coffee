WebSocket = require 'ws'
WebSocketServer = WebSocket.Server

wss = new WebSocketServer({ port: 9001 })

wss.on('connection', (ws) ->

  handler =
    open: () ->
    message: () ->
    close: () ->

  ['open', 'message', 'close'].forEach((event) ->
    ws.on( event, handler[event] )
    )

)
