extends Node2D

var MAX_PLAYERS : int = 0 #initialized but value changed by main node
@onready var MP_player_spawner = $playerSpawner

@onready var MP_player_spawner_node = $players
func _ready() -> void:
	if !multiplayer.is_server():
		return
	#MP_player_spawner.set_spawn_function(on_player_connected)
	MP_player_spawner.spawn_limit = MAX_PLAYERS
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_disconnected.connect(on_player_disconnected)
	for id in multiplayer.get_peers():
		on_player_connected(id)
	on_player_connected(1)

func on_player_connected(id : int):
	print("player peer has connected with id of %s" %id)
	var MP_player_scene = load("res://player/player.tscn")
	var player_instance = MP_player_scene.instantiate()
	player_instance.player = id
	player_instance.name = str(id)
	MP_player_spawner_node.add_child(player_instance, true)
		
func on_player_disconnected(id : int):
	print("player with id %s has disconnected" %id)
	if not MP_player_spawner_node.has_node(str(id)):
		return
	MP_player_spawner_node.get_node(str(id)).call_deferred("queue_free")

func _exit_tree() -> void:
	if !multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(on_player_connected)
	multiplayer.peer_disconnected.disconnect(on_player_connected)
	
@rpc("authority", "call_local", "reliable")
func spawn_enemy():
	pass
