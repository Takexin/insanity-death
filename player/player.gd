extends CharacterBody2D


const SPEED = 30000.0
const ACCEL = 60

@onready var gun_common = $GunCommon

@export var HEALTH = 100
@onready var healthBar = $CanvasLayer/Control/ProgressBar

func _ready() -> void:
	healthBar.value = HEALTH

func takeDamage() -> void:
	HEALTH -= 30
	healthBar.value = HEALTH

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("actionLeft","actionRight","actionUp","actionDown")

	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * SPEED * delta, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)

	if direction.y:
		velocity.y = move_toward(velocity.y, direction.y * SPEED * delta, ACCEL)
	else:
		velocity.y = move_toward(velocity.y, 0, ACCEL)
	
	if Input.is_action_pressed("actionMouseDown"):
		gun_common.shoot()
	if Input.is_action_pressed("actionReset"):
		get_tree().reload_current_scene()


	move_and_slide()
