extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var disableShield: bool = false
@export var shootProjectile: bool = false


func _ready() -> void:
	state = "default"
	health = 7
	GlobalScript.set_stage_name("SNOWY MOUNTAIN")


func _physics_process(delta: float) -> void:
	calculate_player_distance()
	#var distance_y=global_position.y-GlobalScript.playerposy
	spawn_collectables()
	hurtFlash($IceJoe)
	playerdamagevalue = 5
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if abs(distance_x) < 10 and (abs(distance_y) < 30):
		if is_on_floor():
			state = "jump"
	if distance_x < 0:
		$IceJoe.flip_h = false
		$IceJoe.offset.x = 0
	elif distance_x >= 0:
		$IceJoe.flip_h = true
		$IceJoe.offset.x = -14

	if shootProjectile == true:
		var projectile = preload("res://enemy/original/original_projs/ice_joe_projectile.tscn").instantiate()
		get_parent().add_child(projectile)
		match $IceJoe.flip_h:
			false:
				projectile.direction = "left"
				projectile.global_position = $Marker2D_L.global_position
			true:
				projectile.direction = "right"
				projectile.global_position = $Marker2D_R.global_position
		shootProjectile = false
	if disableShield == true:
		$shield_Hitbox/L.set_deferred("disabled", true)
		$shield_Hitbox/R.set_deferred("disabled", true)
	elif disableShield == false:
		match $IceJoe.flip_h:
			false:
				$shield_Hitbox/L.set_deferred("disabled", false)
				$shield_Hitbox/R.set_deferred("disabled", true)
			true:
				$shield_Hitbox/L.set_deferred("disabled", true)
				$shield_Hitbox/R.set_deferred("disabled", false)
	match state:
		"shoot":
			#if $AnimationPlayer.current_animation!="shoot":
			#$AnimationPlayer.play("shoot")
			pass
		"default":
			$AnimationPlayer.play("default")
		"jump":
			$detectPlayerArea/CollisionShape2D.set_deferred("disabled", false)
			$AnimationPlayer.play("jump")
			if is_on_floor() and abs(distance_x) >= 30:
				state = "default"
			if is_on_floor():
				velocity.y = -20000 * delta

	move_and_slide()


func _on_detect_player_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		if $shootTimer.is_stopped() == true:  #and is_on_floor()
			$shootTimer.start()
			$detectPlayerArea/CollisionShape2D.set_deferred("disabled", true)


func _on_shoot_timer_timeout() -> void:
	state = "shoot"
	$AnimationPlayer.play("shoot")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"shoot":
			$AnimationPlayer.play("default")
			$detectPlayerArea/CollisionShape2D.set_deferred("disabled", false)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
