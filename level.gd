extends Node2D

var MAX_PLAYERS : int = 0 #initialized but value changed by main node
@onready var MP_player_spawner = $playerSpawner
@onready var MP_player_scene = preload("res://player/player.tscn")
@onready var MP_player_spawner_node = $players
func _ready() -> void:
	if !multiplayer.is_server():
		return
	MP_player_spawner.spawn_limit = MAX_PLAYERS
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_connected.connect(on_player_disconnected)
	on_player_connected(1)

func on_player_connected(id : int):
	var player_instance = MP_player_scene.instantiate()
	player_instance.player = id
	MP_player_spawner_node.add_child(player_instance, true)
		
func on_player_disconnected(id : int):
	if not MP_player_spawner_node.has_node(str(id)):
		return
	MP_player_spawner_node.get_node(str(id)).call_deferred("queue_free")
