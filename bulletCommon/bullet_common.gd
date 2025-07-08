extends CharacterBody2D
@export_range(0.1,1,0.05) var damage = 0.1

var direction : Vector2 = Vector2.RIGHT
var initialSpeed : float = 0.0
var targetSpeed : float = 0.0
var accel : float = 0.0
var speed : float = 0.0
var cooldown : float = 0.0
signal enemyHit 

func _ready() -> void:
	direction = direction.rotated(global_rotation)
	speed = initialSpeed 
	
	await get_tree().create_timer(cooldown).timeout
	queue_free()

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.is_in_group("enemy"):
		enemyHit.emit(damage)

func _physics_process(delta: float) -> void:
	speed = lerp(speed, targetSpeed, accel * delta)
	velocity = direction * speed * delta * 300
	
	#velocity = direction * 10**targetSpeed
	var collision  = move_and_collide(velocity * delta)
	if collision:
		queue_free()
