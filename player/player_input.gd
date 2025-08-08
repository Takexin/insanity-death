extends MultiplayerSynchronizer

@export var direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
func _process(delta: float) -> void:
	direction = Input.get_vector("actionLeft","actionRight","actionUp","actionDown")
	print(direction)
