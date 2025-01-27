extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	health=4
func _physics_process(delta: float) -> void:
	# Add the gravity.
	playerdamagevalue=4
	if not is_on_floor():
		velocity += get_gravity() * delta
	#if $coolDown.is_stopped()==false:
		#$detectPlayer/CollisionShape2D.disabled=true
		#
	#elif $coolDown.is_stopped()==true:
		#$detectPlayer/CollisionShape2D.disabled=false
	if distance_x>0:
		$AnimatedSprite2D.flip_h=true
	if distance_x<0:
		$AnimatedSprite2D.flip_h=false
	if GlobalScript.health<=0:
		$AnimatedSprite2D.stop()
	spawn_collectables()
	calculate_player_distance()
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"throw":
			var grenade=preload("res://enemy/original/original_projs/grenade_projectile_2.tscn").instantiate()
			get_parent().add_child(grenade)
			grenade.global_position=$Marker2D.global_position
			#var grenade=preload("res://enemy/original/grenade_projectile_grenademan.tscn").instantiate()
			#get_parent().add_child(grenade)
			#grenade.global_position=$Marker2D.global_position
			#grenade._throwtoPlayer(1)
			
			#grenade._throwtoPlayer(1)
			#grenade.launch(global_position,Vector2(-100,0),-300,45)
			$AnimatedSprite2D.play("standby")


func _on_animated_sprite_2d_animation_looped() -> void:
	match $AnimatedSprite2D.animation:
		"throw":
			#var grenade=preload("res://enemy/original/grenade_projectile_grenademan.tscn").instantiate()
			#get_parent().add_child(grenade)
			#grenade.global_position=$Marker2D.global_position
			#grenade._throwtoPlayer(1)
			#var grenade=preload("res://enemy/original/original_projs/grenade_projectile_2.tscn").instantiate()
			#get_parent().add_child(grenade)
			#grenade.global_position=$Marker2D.global_position
			
			#if health>0
			var grenade=preload("res://enemy/original/original_projs/grenade_projectile_2.tscn").instantiate()
			get_parent().add_child(grenade)
			if distance_x<0:
				grenade.global_position=$grenadeThrowPosL.global_position
			if distance_x>0:
				grenade.global_position=$grenadeThrowPosR.global_position
			#$detectPlayer/CollisionShape2D.disabled=false

func _on_detect_player_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		#if health>0:
		$AnimatedSprite2D.play("throw")
			#$coolDown.start()

func _on_detect_player_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		$AnimatedSprite2D.stop()
		#$coolDown.stop()
		pass
	pass
