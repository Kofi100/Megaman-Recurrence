extends enemy
var hasJumped:bool=false
var triggerExplosion:bool=false
func _ready() -> void:
	state="idle"
	$Timer.autostart=false
	health=5

func _physics_process(delta: float) -> void:
	pass
	calculate_player_distance()
	#$Timer.wait_time=
	playerdamagevalue=3
	#$RayCast2D.position.y=35
	if $AnimatedSprite2D.animation=="idle" or $AnimatedSprite2D.animation=="jump":
		if distance_x<0:
			$AnimatedSprite2D.flip_h=false
		elif distance_x>=0:
			$AnimatedSprite2D.flip_h=true
	if not is_on_floor() and triggerExplosion==false:
		velocity.y+=get_gravity().y*delta
	match state:
		"idle":
			$AnimatedSprite2D.play("idle")
		"jump":
			$AnimatedSprite2D.play("jump")
		"art":
			pass
			$AnimatedSprite2D.play("artISANEXPLOSION")
	if abs(distance_x)<=20:
		if not hasJumped:
			state='jump'
			velocity.y=-10000*delta
			$CollisionShape2D_Idle.set_deferred("disabled",true)
			$CollisionShape2D_Jump.set_deferred("disabled",true)
			if $Timer.is_stopped():
				$Timer.start()
				#print($Timer.is_stopped())
			#await get_tree().create_timer(.3).timeout#wait for .2s
			
			hasJumped=true
	#print(velocity.y)
	if ($RayCast2D.is_colliding() and hasJumped==true ) or(health<=0):
		velocity=Vector2.ZERO
		triggerExplosion=true
		if $AnimatedSprite2D.animation!="artISANEXPLOSION":
			state="art"
			$AnimatedSprite2D.play("artISANEXPLOSION")
	
	#print($CollisionShape2D_Idle.disabled)
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"artISANEXPLOSION":
			var explosion=preload("res://enemy/boss/count_bomb_explosion_radius.tscn").instantiate()
			add_child(explosion)
			explosion.parent=self
			explosion.scale=Vector2(2,2)
			explosion.playerdamagevalue=5


func _on_timer_timeout() -> void:
	$CollisionShape2D_Jump.set_deferred("disabled",false)


func _on_tree_exiting() -> void:
	spawn_collectables()
