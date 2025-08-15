extends Node2D

@export var enemies : Array[PackedScene] = []
func _ready() -> void:
	randomize()

#getters and setters
func set_enemy_list(enemies: Array[PackedScene]) -> void: 
	enemies = enemies
func get_enemy_list() -> Array[PackedScene]:
	return enemies

func spawn_enemy(spawn_area : Vector2) -> Node2D:
	var enemy_pool = enemies.size()-1 #get enemy index
	var enemy : int = randi_range(0, enemy_pool)
	
	var enemyInstance = enemies[enemy].instantiate()
	enemyInstance.position.x = randf_range(0, spawn_area.x)
	enemyInstance.position.y = randf_range(0, spawn_area.y)
	return enemyInstance
