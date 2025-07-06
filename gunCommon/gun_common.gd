@tool
class_name gun_common
extends Node2D

@export_group("Gun Properties")

@export_range(0.1,5,0.05) var cooldown = 0.0
@export_range(0.1,1,0.05) var turnSpeed = 0.1
@export_range(0,10,0.1) var recoil = 0.0
@export_group("Bullet")
@export_enum("Projectile:1", "Lazer:2") var bulletType = 1:
	set(value):
		if value == bulletType : return
		bulletType = value
		notify_property_list_changed() 

var fireModeEnum = {"Single" : 0, "Spread" : 1}
var fireMode : int = 0:
	set(value):
		if value == fireMode : return
		fireMode = value
		notify_property_list_changed() 
var bulletInitialSpeed : float = 1.0
var bulletTargetSpeed : float = 1.0
var bulletAccel : float = 1.0
var dmgDropoff : float = 1.0

var bulletAmmount : int = 1
var bulletSpreadRange : float = 0.1
func _get_property_list():
	if Engine.is_editor_hint():
		var ret = []
		if bulletType == 1:
			ret.append({
				"name": &"fireMode",
				"type" : TYPE_INT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : PROPERTY_HINT_ENUM,
				"hint_string" : ",".join(fireModeEnum.keys())
			})
			ret.append({
				"name" : &"bulletInitialSpeed",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0.1,10.0,0.05"
			})
			ret.append({
				"name" : &"bulletTargetSpeed",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0.1,10.0,0.05"
			})
			ret.append({
				"name" : &"bulletAccel",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0.1,10.0,0.05"
			})
			ret.append({
				"name" : &"bulletSpreadRange",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0.1,10.0,0.05"
				})
			ret.append({
				"name" : &"dmgDropoff",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0.1,10.0,0.05"
			})
			if fireMode == 1:
				ret.append({
				"name" : &"bulletAmmount",
				"type" : TYPE_INT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "1,100, or_greater"
				})
				
		return ret
@export var bullet:Resource

@onready var player = get_parent()
@onready var shootAnchor = $shootAnchor
@onready var cooldownTimer = $cooldown

func _physics_process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	
	var turnRate = turnSpeed
	#look_at(get_global_mouse_position())
	#rotation = get_global_mouse_position().angle_to_point(position)
	#print(get_angle_to(mouse))
	#print(global_position - mouse)
	
	if rotation > PI/2 or rotation < -PI/2:
		scale.y = -1
	else:
		scale.y = 1
	#look_at(mouse.lerp(global_position - mouse, 0.01))
	# if ((atan2(mouse.y, mouse.x)) - rotation) < -1.8*PI:
	rotation = lerpf(rotation, get_angle_to(mouse) + rotation, turnRate * delta * 25)
	# rotation = (atan2(mouse.y, mouse.x))
	#     rotate(lerpf( abs(atan2(mouse.y, mouse.x)) - rotation + 2*PI, 0, turnRate))
	# else:
	#     rotation = move_toward(rotation, get_global_mouse_position().angle_to_point(player.position), turnSlowness)


func on_hit_enemy(damage : float):
	pass

func shoot():
	var bulletInstance : Node2D = bullet.instantiate()
	bulletInstance.global_position = shootAnchor.global_position
	bulletInstance.top_level = true
	bulletInstance.global_rotation = global_rotation

	bulletInstance.initialSpeed = bulletInitialSpeed
	bulletInstance.targetSpeed = bulletTargetSpeed
	bulletInstance.accel = bulletAccel

	add_child(bulletInstance)
