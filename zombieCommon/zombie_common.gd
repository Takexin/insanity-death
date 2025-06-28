extends CharacterBody2D

@export var SPEED = 10
@export var ACCEL = 60
@export var DAMAGE = 10

@onready var player = get_parent().get_node_or_null("Player")

func _physics_process(delta: float) -> void:
	# Add the gravity.

	# Handle jump.
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = player.position - position

	if direction.x:
		velocity.x = direction.x * SPEED * delta
		
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)

	if direction.y:
		velocity.y = direction.y * SPEED * delta
		
	else:
		velocity.y = move_toward(velocity.y, 0, ACCEL)

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player.takeDamage()
