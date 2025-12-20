extends CharacterBody2D
#code has to be refactored asap to be like Megaman's spawn.
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var spawn_in_speed=30000
@export var spawn_back_speed=120000
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var stop_normal_movements:bool=false
var spawn_rush=false
var spawn_back=false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980#ProjectSettings.get_setting("physics/2d/default_gravity")
var play=0
func _ready():
	$AnimatedSprite2D.visible=false
	animated_sprite_2d.play("idle")
	state=MiniState.NOT_READY
	#GlobalLogger.debug(name,"state:%s"%state)
	#await get_tree().create_timer(.5).timeout
	#create_spawn_effect()
	#spawn_rush=true
var spawn_play=0;var just_landed:bool=false
enum MiniState{IDLE,SPAWN_OUT,SPAWN_IN,NOT_READY,SPRING}
var state:MiniState
var landed_on_floor:bool=false
var cutscene_stop_move_back_timer:bool=false
func _physics_process(delta):
	#GlobalLogger.debug(name,"landed_on_floor:%s"%landed_on_floor)
	match state:
		MiniState.IDLE:
			if not is_on_floor():
				velocity.y+=gravity*delta
			$AnimatedSprite2D.visible=true
			$AnimatedSprite2D.play("idle")
			$jump_zone/CollisionShape2D.set_deferred("disabled",false)
			if cutscene_stop_move_back_timer==false:
				if $move_back_timer.is_stopped():
					$move_back_timer.start()
		MiniState.NOT_READY:
			if not is_on_floor():
				#had to make it like this since rush is supposed to detect the ground before 
				#creating the spawn effect
				velocity.y=200000*delta#+=gravity*delta
			if is_on_floor() and not landed_on_floor:
				#var spawn_effect=preload("res://players/weapons/rush_coil_spawn_effect.tscn").instantiate()
				#
				#spawn_effect.global_position=global_position-Vector2(0,224)
				#get_tree().current_scene.add_child(spawn_effect)
				create_spawn_effect(true)
				#GlobalLogger.debug(name,"spawn effect should be spawning now")
				landed_on_floor=true
			$AnimatedSprite2D.visible=false
			$jump_zone/CollisionShape2D.set_deferred("disabled",true)
			
		MiniState.SPAWN_IN:
			$AnimatedSprite2D.visible=true
		MiniState.SPRING:
			if not is_on_floor():
				velocity.y+=gravity*delta
			#$AnimatedSprite2D.play("spring")
		MiniState.SPAWN_OUT:
			queue_free()
	move_and_slide()
	offset()

func offset():
	if animated_sprite_2d.animation=="spawn":
		animated_sprite_2d.offset=Vector2(-3,3)
	else:
		animated_sprite_2d.offset=Vector2.ZERO

func create_spawn_effect(spawning_in:bool=true):
	#if state != MiniState.NOT_READY or state!=MiniState.SPAWN_OUT:
		#return
	
	var spawn_effect = preload("res://players/weapons/rush_coil_spawn_effect.tscn").instantiate()
	# Try a smaller offset or no offset
	if spawning_in:
		spawn_effect.global_position = global_position  - Vector2(0, 224)# if needed
	else:
		spawn_effect.global_position = global_position
	spawn_effect.rush_spawning_in=spawning_in
	get_tree().current_scene.add_child(spawn_effect)
	
	GlobalLogger.debug(name,
	 "Spawn effect created at position: %s with rush spawning_in of value:%s" % 
	[spawn_effect.global_position,spawning_in])
	
	# Change state after effect is created
	#state = MiniState.SPAWN_IN
	#$AnimatedSprite2D.visible = true
	#$AnimatedSprite2D.play("spawn")

func _on_jump_zone_body_entered(body):
	if body.is_in_group("player"):
		if cutscene_stop_move_back_timer==false:
			body.velocity.y=-400#(-1200/3)
		elif cutscene_stop_move_back_timer==true:
			body.velocity.y=-2000#(-1200/3)
		animated_sprite_2d.play("spring")
		state=MiniState.SPRING
		if cutscene_stop_move_back_timer==false:
			$move_back_timer.start()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation=="spring":
		animated_sprite_2d.play("idle")
	if animated_sprite_2d.animation=="spawn":
		#animated_sprite_2d.play("idle")
		state=MiniState.IDLE


func _on_move_back_timer_timeout():
	#spawn_back=true
	#queue_free()
	$AnimatedSprite2D.play("spawn")
	state=MiniState.SPAWN_OUT
	create_spawn_effect(false)
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	#queue_free()
	pass
#this could be why rush was being deleted wayy too often
#func delete():queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("rush_spawn_effect"):
		var node=area.get_parent()
		node.queue_free()
		if state==MiniState.NOT_READY:
			state=MiniState.SPAWN_IN
			$AnimatedSprite2D.play("spawn")
