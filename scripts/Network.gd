extends Node

var ws: WebSocketClient
var init: bool = true

func _ready():
	ws = WebSocketClient.new()
	# warning-ignore:return_value_discarded
	ws.connect("data_received", self, "_on_received_data")
	# warning-ignore:return_value_discarded
	ws.connect("connection_closed", self, "_connection_closed")
	# warning-ignore:return_value_discarded
	ws.connect("connection_error", self, "_connection_error")
	# warning-ignore:return_value_discarded
	ws.connect("connection_established", self, "_connection_established")
	print(ws.connect_to_url("ws://localhost:8000"))

func _process(_delta: float) -> void:
	ws.poll()

func _on_received_data() -> void:
	print("data")
	pass

func _connection_closed(_clean) -> void:
	print("Websocket: connection closed")
	print(ws.connect_to_url("ws://localhost:8000"))

func _connection_error() -> void:
	print("Websocket: connection error")

func _connection_established(_proto) -> void:
	if init:
		send_event({
			"event": "startup"
		})
		init = false

func send_event(msg):
	print(msg)
	# warning-ignore:return_value_discarded
	ws.get_peer(1).put_packet(to_json(msg).to_utf8())
