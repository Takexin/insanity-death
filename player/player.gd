extends CharacterBody2D


const SPEED = 30000.0
const ACCEL = 60

@export var HEALTH = 100
@onready var healthBar = $CanvasLayer/Control/ProgressBar

func _ready() -> void:
	healthBar.value = HEALTH
func takeDamage() -> void:
	HEALTH -= 30
	healthBar.value = HEALTH
func _physics_process(delta: float) -> void:
	# Add the gravity.

	# Handle jump.
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("actionLeft","actionRight","actionUp","actionDown")

	if direction.x:
		#velocity.x = direction.x * SPEED * delta
		velocity.x = move_toward(velocity.x, direction.x * SPEED * delta, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)

	if direction.y:
		#velocity.y = direction.y * SPEED * delta
		velocity.y = move_toward(velocity.y, direction.y * SPEED * delta, ACCEL)
	else:
		velocity.y = move_toward(velocity.y, 0, ACCEL)

	move_and_slide()
