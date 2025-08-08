extends Node

const PORT = 7000
const DEFAULT_IP = "127.0.0.1"
const MAX_PLAYERS = 10

@onready var UI_selector = $UI/selector
@onready var UI_client_popup = $UI/client_popup

@onready var UI_ip_edit = $UI/client_popup/HBoxContainer/VBoxContainer/ip_edit
@onready var UI_port_edit = $UI/client_popup/HBoxContainer/VBoxContainer/port_edit

@onready var WORLD_node = $world
@onready var WORLD_level = preload("res://level.tscn")
func _on_server_pressed() -> void:
	print('server')
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_PLAYERS)
	if error:
		print("error on creating server")
		return
	UI_selector.hide()
	multiplayer.multiplayer_peer = peer
	start_game()
		
	
func _on_client_pressed() -> void:
	UI_selector.hide()
	UI_client_popup.show()
	
func _on_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var ip = UI_ip_edit.text
	var port = UI_port_edit.text
	
	if ip == "":
		ip = DEFAULT_IP
	if port == "":
		port = PORT
		 
	var error = peer.create_client(ip, port)
	if error:
		print("error on creating client")
		return
		
	UI_client_popup.hide()
	multiplayer.multiplayer_peer = peer
	start_game()
	
func start_game():
	var level_instance = WORLD_level.instantiate()
	level_instance.MAX_PLAYERS = MAX_PLAYERS
	WORLD_node.add_child(level_instance)
