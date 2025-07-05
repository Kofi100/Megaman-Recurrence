extends enemy
var shootOnce:bool=false
func _ready() -> void:
	#$AnimatedSprite2D.animation="defend"
	$AnimatedSprite2D.play("idle")
	#$AnimatedSprite2D.frame=2
	
	#$defend_Timer.start()
	health=5
	playerdamagevalue=3
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
	calculate_player_distance()
	spawn_collectables()
	$shoot_Timer.wait_time=.3
	if distance_x<0:
		$AnimatedSprite2D.flip_h=false
		
	elif distance_x>=0:
		$AnimatedSprite2D.flip_h=true
	if abs(distance_x)<=135 and abs(distance_y)<=120:
		if $AnimatedSprite2D.animation=="idle" and $shoot_Timer.is_stopped():
			$shoot_Timer.start()
		if $AnimatedSprite2D.animation=="defend" and $defend_Timer.is_stopped():
			$defend_Timer.start()
		#print(abs(distance_x)," ",abs(distance_y))
	if distance_x<0:
		if ($AnimatedSprite2D.animation=="defend" and $AnimatedSprite2D.frame==2) or ($AnimatedSprite2D.animation=="remove_defend" and $AnimatedSprite2D.frame==0) :
			$shieldHitbox/L.disabled=false
			$shieldHitbox/R.disabled=true
		else:
			$shieldHitbox/L.disabled=true
			$shieldHitbox/R.disabled=true
	elif distance_x>=0:
		if ($AnimatedSprite2D.animation=="defend" and $AnimatedSprite2D.frame==2) or ($AnimatedSprite2D.animation=="remove_defend" and $AnimatedSprite2D.frame==0) :
			$shieldHitbox/L.disabled=true
			$shieldHitbox/R.disabled=false
		else:
			$shieldHitbox/L.disabled=true
			$shieldHitbox/R.disabled=true
	if $AnimatedSprite2D.animation=="shoot":
		if $AnimatedSprite2D.frame==2 and shootOnce==false:
			var proj=preload("res://enemy/quad_cannon_projectile.tscn").instantiate()
			if distance_x<0:
				proj.global_position=$Marker2DL.global_position
			elif distance_x>=0:
				proj.global_position=$Marker2DR.global_position
			get_tree().current_scene.add_child(proj)
			shootOnce=true
		elif $AnimatedSprite2D.frame!=2:
			shootOnce=false

func _on_shoot_timer_timeout() -> void:
	$AnimatedSprite2D.play("shoot")


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"shoot":
			$AnimatedSprite2D.play("defend")
		"defend":
			$defend_Timer.start()
		"remove_defend":
			$AnimatedSprite2D.play("idle")
			#$shoot_Timer.start()
			$detectionArea/AdjustableCollisionShape2D.disabled=false


func _on_defend_timer_timeout() -> void:
	$AnimatedSprite2D.play("remove_defend")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

#var playerAround
func _on_detection_area_area_entered(area: Area2D) -> void:
	#if area.is_in_group("player_constants_checker_area2d"):
		#$shoot_Timer.start()
		#$detectionArea/AdjustableCollisionShape2D.disabled=true
	pass
