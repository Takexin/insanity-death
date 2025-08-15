@tool
class_name gun_common
extends Node2D

@onready var bullets = $bullets
@export_group("Gun Properties")

@export_range(0.1,5,0.05) var fireRate = 1.0
@export_range(0.1,1,0.05) var turnSpeed = 0.1
@export_range(0,10,0.1) var recoil = 0.0
@export_group("Bullet")
@export var damage : int = 1
@export_enum("Projectile:1", "Lazer:2") var bulletType = 1:
	set(value):
		if value == bulletType : return
		bulletType = value
		notify_property_list_changed() 

var canShoot = true
var fireModeEnum = {"Single" : 0, "Spread" : 1}
var fireMode : int = 0:
	set(value):
		if value == fireMode : return
		fireMode = value
		notify_property_list_changed() 
var bulletLifeSpan : float = 1.0
var bulletInitialSpeed : float = 240.0
var bulletTargetSpeed : float = 240.0
var bulletAccel : float = 0.0
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
				"name" : &"bulletLifeSpan",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0.0,10.0,0.05"
			})
			ret.append({
				"name" : &"bulletInitialSpeed",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0,400,5"
			})
			ret.append({
				"name" : &"bulletTargetSpeed",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0,400,5"
			})
			ret.append({
				"name" : &"bulletAccel",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0.0,10.0,0.05"
			})
			ret.append({
				"name" : &"bulletSpreadRange",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_DEFAULT,
				"hint" : 1,
				"hint_string": "0.1,360.0,0.05"
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
@export var bullet:PackedScene

@onready var player = get_parent().get_parent()
@onready var shootAnchor = $shootAnchor
@onready var cooldownTimer = $cooldown

func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	randomize()

func _physics_process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	
	var turnRate = turnSpeed
	if rotation >= 2*PI:
		rotation -= 2*PI
	elif rotation <= -2*PI:
		rotation += 2*PI
	if rotation > (PI/2):
		scale.y = -1
		rotation -= 2*PI
	elif rotation < -PI/2:
		rotation += 2*PI
	else:
		scale.y = 1
	rotation = (lerpf(rotation, get_angle_to(mouse) + rotation, turnRate * delta * 25))
	

func on_hit_enemy(damage : float):
	pass
@rpc("any_peer", "call_local", "unreliable")
func shoot():
	if canShoot:
		canShoot = false
		for i in bulletAmmount:
			var bulletInstance : Node2D = bullet.instantiate()
			bulletInstance.global_position = shootAnchor.global_position
			bulletInstance.top_level = true
			bulletInstance.rotation = randfn(rotation, deg_to_rad(bulletSpreadRange))
			bulletInstance.initialSpeed = bulletInitialSpeed
			bulletInstance.targetSpeed = bulletTargetSpeed
			bulletInstance.accel = bulletAccel
			bulletInstance.cooldown = bulletLifeSpan
			bulletInstance.damage = damage
			
			bullets.add_child(bulletInstance,true)
		await get_tree().create_timer(1/fireRate).timeout
		canShoot = true
