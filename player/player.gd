extends CharacterBody2D


const SPEED = 30000.0
const ACCEL = 60

@onready var input = $playerInput
@onready var animation_player = $AnimatedSprite2D
@export var player := 1:
	set(id):
		player = id
		print("ID SET TO  %s" %id)
		$playerInput.set_multiplayer_authority(id)
		for gun in $guns.get_children():
			gun.set_multiplayer_authority(id)


@onready var gun_common = $guns/GunCommon

@export var HEALTH = 100
@onready var healthBar = $CanvasLayer/Control/ProgressBar

func _ready() -> void:
	healthBar.value = HEALTH
	if player == multiplayer.get_unique_id():
		$Camera2D.make_current()

func takeDamage() -> void:
	HEALTH -= 30
	healthBar.value = HEALTH

func _physics_process(delta: float) -> void:
	var direction = input.direction
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * SPEED * delta, ACCEL)
		if direction.x < 0:
			animation_player.scale.x = abs(animation_player.scale.x) * -1
		else:
			animation_player.scale.x = abs(animation_player.scale.x)
		animation_player.play("lilly_run")
		
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
	if direction.y:
		velocity.y = move_toward(velocity.y, direction.y * SPEED * delta, ACCEL)
		animation_player.play("lilly_run")
	else:
		velocity.y = move_toward(velocity.y, 0, ACCEL)
	if direction == Vector2(0,0):
		animation_player.play("lilly_idle")

	if Input.is_action_pressed("actionMouseDown"):
		gun_common.shoot()
	#if Input.is_action_pressed("actionReset"):
		#get_tree().reload_current_scene()


	move_and_slide()
