extends CharacterBody2D
class_name Player_Projectile

@export var SPEED:float = 50000.0
@export var direction:String = "left"
@export var state:String = "active"
@export var damagevalue:float = 1
@export var health=1
@export var shouldBeDestroyedByLaserSwitch:bool=true
var light :Light2D

func add_light_effect(radius:float=0.5):
	var new_light_radius =preload("res://resources/light_radius_projectiles.tscn").instantiate()
	new_light_radius.visible=false
	add_child(new_light_radius)
	new_light_radius.scale = Vector2(radius,radius)
	light = new_light_radius

func light_active_effect(animatedsprite):
	if animatedsprite == null or not(animatedsprite is AnimatedSprite2D or animatedsprite is Sprite2D):
		return
	if light == null:
		return
	#breakpoint
	light.visible= GlobalScript.slumbshade_darkness_active and animatedsprite.visible
	#print(GlobalScript.slumbshade_darkness_active,animatedsprite.visible,light.visible)
