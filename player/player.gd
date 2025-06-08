extends CharacterBody2D


const SPEED = 15	000.0
const JUMP_VELOCITY = -400.0
const ACCEL = 150


func _physics_process(delta: float) -> void:
	# Add the gravity.

	# Handle jump.
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("actionLeft","actionRight","actionUp","actionDown")

	if direction.x:
		velocity.x = direction.x * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)

	if direction.y:
		velocity.y = direction.y * SPEED * delta
	else:
		velocity.y = move_toward(velocity.y, 0, ACCEL)

	move_and_slide()
