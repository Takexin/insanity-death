extends CharacterBody2D
@export_range(0.1,1,0.05) var damage = 0.1

var direction : Vector2 = Vector2.RIGHT
var initialSpeed : float = 0.0
var targetSpeed : float = 0.0
var accel : float = 0.0

signal hitEnemy

func _ready() -> void:
    direction = Vector2.RIGHT.rotated(global_rotation)
    velocity.x = initialSpeed * direction.x
    velocity.y = initialSpeed * direction.y

func _on_area_2d_body_entered(body:Node2D) -> void:
    if body.is_in_group("enemy"):
        hitEnemy.emit(damage)
func _physics_process(delta: float) -> void:
    velocity.x = move_toward(velocity.x, direction.x * targetSpeed*100, accel * delta * 100)
    velocity.y = move_toward(velocity.y, direction.y * targetSpeed*100, accel * delta * 100)
    move_and_slide()