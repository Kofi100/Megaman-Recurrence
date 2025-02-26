extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _ready() -> void:
	health = 10
	$AnimatedSprite2D.play("idle")


func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	playerdamagevalue = 5

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#if $attackTimer.is_stopped() == true:
	#$AnimatedSprite2D.play("idle")
	if distance_x > 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.offset.x = -8
	elif distance_x < 0:
		$AnimatedSprite2D.offset.x = 8
		$AnimatedSprite2D.flip_h = false
	if $AnimatedSprite2D.animation == "idle":
		match $AnimatedSprite2D.flip_h:
			true:
				$shieldHitbox/L.disabled = true
				$shieldHitbox/R.disabled = false
			false:
				$shieldHitbox/L.disabled = false
				$shieldHitbox/R.disabled = true
	elif $AnimatedSprite2D.animation == "shoot":
		$shieldHitbox/L.disabled = true
		$shieldHitbox/R.disabled = true

	move_and_slide()


var hasPlayerEntered = false


func _on_player_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d") and hasPlayerEntered == false:
		$attackTimer.start()
		hasPlayerEntered = true


func _on_attack_timer_timeout() -> void:
	$AnimatedSprite2D.play("shoot")


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"shoot":
			$attackPeriodTimer.start()
			$attackPeriodTimer/spawnProjectileTimer.start()
			$playerDetect/CollisionShape2D.set_deferred("disabled", true)


func _on_spawn_projectile_timer_timeout() -> void:
	var proj = preload("res://enemy/original/original_projs/sniper_joe_variant_fire_projectile.tscn").instantiate()
	get_parent().add_child(proj)
	proj.global_position = global_position
	match $AnimatedSprite2D.flip_h:
		true:
			proj.direction = Vector2(1, 0)
		false:
			proj.direction = Vector2(-1, 0)
	$all_sounds/shoot.play()


func _on_attack_period_timer_timeout() -> void:
	$attackPeriodTimer/spawnProjectileTimer.stop()
	$AnimatedSprite2D.play("idle")
	$playerDetect/CollisionShape2D.set_deferred("disabled", false)
	hasPlayerEntered = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
