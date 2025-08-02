@tool
extends StaticBody2D
var WentThruLeftDoor:bool=false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animated_sprite_2d_2 = $AnimatedSprite2D2

@export var spriteframes:SpriteFrames
@export var whiteReplacement:Color
@export var bossToWaitFor:CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# Make materials unique and local to scene
	#animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
	#animated_sprite_2d.material.resource_local_to_scene = true
	#animated_sprite_2d_2.material = animated_sprite_2d_2.material.duplicate()
	#animated_sprite_2d_2.material.resource_local_to_scene = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#code here is supposed to run in and outta editor
	#makes material and shader code to run in editor
	#by settign it to be local to scene
	#can also be done in the shaderMaterial by going
	#to Resource>Local To Scene
	#animated_sprite_2d.material.resource_local_to_scene=true
	#animated_sprite_2d_2.material.resource_local_to_scene=true
	#change_color(animated_sprite_2d,greyReplacement,whiteReplacement)
	#change_color(animated_sprite_2d_2,greyReplacement,whiteReplacement)
	if spriteframes!=null:
		$AnimatedSprite2D.sprite_frames=spriteframes
		$AnimatedSprite2D2.sprite_frames=spriteframes
	else:
		$AnimatedSprite2D.sprite_frames=load("res://levels/level_mechanics/doorAnimationTemplate.tres")
		$AnimatedSprite2D2.sprite_frames=load("res://levels/level_mechanics/doorAnimationTemplate.tres")
	if Engine.is_editor_hint():
		pass
	elif not Engine.is_editor_hint():
		if animated_sprite_2d.animation=='open_close':
			if animated_sprite_2d.frame==4:
				$CollisionShape2D.disabled=true
			else:
				$CollisionShape2D.disabled=false
		if GlobalScript.playerposx>$detect_right/CollisionShape2D2.global_position.x:
			if not exited_door:
				animated_sprite_2d.frame=0
				animated_sprite_2d_2.frame=0
		if bossToWaitFor!=null:
			if "health" in bossToWaitFor:
				if bossToWaitFor.health>0:
					$detect_left/CollisionShape2D.disabled=true
				else:
					$detect_left/CollisionShape2D.disabled=false
	



func _on_detect_left_body_entered(body):
	if body.is_in_group('player'):
		body.stop=true
		body.door_transition=true
		animated_sprite_2d.play("open_close")
		animated_sprite_2d_2.play("open_close")
		WentThruLeftDoor=true
		$door_enter_close.play()
		

var exited_door=false
func _on_detect_right_body_entered(body):
	if body.is_in_group('player') and WentThruLeftDoor:
		exited_door=true
		animated_sprite_2d.play_backwards("open_close")
		animated_sprite_2d_2.play_backwards("open_close")
		$door_enter_close.play()

func _on_detect_right_body_exited(body):
	if body.is_in_group('player'):
		body.stop=false
		body.door_transition=false
		$detect_right.set_collision_mask_value(2,false)
		body.velocity.x=0
		#$detect_right/CollisionShape2D2.disabled=true
#		$detect_right/CollisionShape2D2.call_deferred('is_disabled',true)#'is_disabled',true)
		#$detect_right/CollisionShape2D2.disabled=true
#var grepl:Vector4;var wrepl:Vector4;#var animated_sprite:AnimatedSprite2D

func change_color(sprite:AnimatedSprite2D,grepl:Color,wrepl:Color):
	pass
	sprite.material.set_shader_parameter('greyReplacement',grepl)
	sprite.material.set_shader_parameter('whiteReplacement',wrepl)
	#print('Gray new:',grepl,'...,White new:',wrepl)
