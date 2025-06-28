@tool
extends Node2D

@export_group("Gun Properties")

@export_range(0.1,5,0.05) var cooldown = 0.0
@export_range(0,10,0.1) var turnSlowness = 0.0
@export_range(0,10,0.1) var recoil = 0.0:
    set(b):
        print(get_script().get_script_property_list() )
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
var bulletSpeed : float = 1.0
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
                "name" : &"bulletSpeed",
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
                ret.append({
                "name" : &"bulletSpreadRange",
                "type" : TYPE_FLOAT,
                "usage" : PROPERTY_USAGE_DEFAULT,
                "hint" : 1,
                "hint_string": "0.1,10.0,0.05"
                })
        return ret
@export var bullet:Resource