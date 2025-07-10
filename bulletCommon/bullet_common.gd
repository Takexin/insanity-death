extends CharacterBody2D
class_name bullet_common

var direction : Vector2 = Vector2.RIGHT
var initialSpeed : float = 0.0
var targetSpeed : float = 0.0
var accel : float = 0.0
var speed : float = 0.0
var cooldown : float = 0.0
var damage = 1
signal enemyHit 

func _ready() -> void:
	direction = direction.rotated(global_rotation)
	speed = initialSpeed 
	
	await get_tree().create_timer(cooldown).timeout
	queue_free()

func _beforeEnemyHit():
	pass

func _physics_process(delta: float) -> void:
	speed = lerp(speed, targetSpeed, accel * delta)
	velocity = direction * speed * delta * 300
	
	var collision  = move_and_collide(velocity * delta)
	if collision:
		await _beforeEnemyHit()
		collision.get_collider().takeDamage(damage)
		queue_free()
