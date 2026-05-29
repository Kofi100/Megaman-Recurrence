extends enemy
var shootOnce:bool=false
var originalPos
var projectile_count:int=0
var is_at_position:bool=false
func _ready() -> void:
	
	health=2
	playerdamagevalue=2
	originalPos=Vector2(global_position.x,global_position.y)#Player.playerCharacter.global_position.y)
	calculate_player_distance()
	
	if distance_x<0:
		$AnimatedSprite2D.flip_h=false
		$AnimatedSprite2D.set_offset(Vector2(0,0))
		$hitbox/L.disabled=false
		$hitbox/R.disabled=true
	elif distance_x>=0:
		$AnimatedSprite2D.flip_h=true
		$AnimatedSprite2D.set_offset(Vector2(-9,0))
		$hitbox/L.disabled=true
		$hitbox/R.disabled=false
	if distance_x<0:
		global_position.x=global_position.x+250
		#global_position.y=Player.playerCharacter.global_position.y
	elif distance_x>=0:
		global_position.x=global_position.x-250
		#global_position.y=Player.playerCharacter.global_position.y
	#print(Player.playerCharacter.global_position.y)
	#print(originalPos)

func _physics_process(delta: float) -> void:
	#print(global_position)
	if (global_position!=originalPos):
		var newx=move_toward(global_position.x,originalPos.x,250*delta)
		#var newy=move_toward(global_position.y,originalPos.y,250*delta)
		global_position.x=newx
		
		#global_position.y=newy
	#if not is_on_floor():
		#velocity+=get_gravity()*delta
	calculate_player_distance()
	hurtFlash($AnimatedSprite2D)
	spawn_collectables()
	if (global_position==originalPos) and not is_at_position:#$shoot_timer.is_stopped():
		$shoot_timer.start(3)
		is_at_position=true
	if (global_position==originalPos) and not $shoot_timer.is_stopped():
		#$shoot_timer.start()
		$AnimatedSprite2D.play("playing")
		if distance_x<0:
			$AnimatedSprite2D.flip_h=false
			$AnimatedSprite2D.set_offset(Vector2(0,0))
			$hitbox/L.disabled=false
			$hitbox/R.disabled=true
		elif distance_x>=0:
			$AnimatedSprite2D.flip_h=true
			$AnimatedSprite2D.set_offset(Vector2(-9,0))
			$hitbox/L.disabled=true
			$hitbox/R.disabled=false
		#if $AnimatedSprite2D.frame and $VisibleOnScreenNotifier2D.is_on_screen(): #%2 ==1
			#if shootOnce==false:
				#var proj=preload("res://enemy/sleepy_harper_projectile.tscn").instantiate()
				#proj.position=position
				#proj.up_direction_variant=projectile_count%5
				#get_tree().current_scene.add_child(proj)
				#
				#projectile_count+=1
				#shootOnce=true
		#else:shootOnce=false
	#print($shoot_timer.time_left)

func _on_shoot_projectile_timeout() -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_animated_sprite_2d_frame_changed() -> void:
	#shootOnce=false
	match $AnimatedSprite2D.animation:
		"playing":
			if $VisibleOnScreenNotifier2D.is_on_screen():
				var proj=preload("res://enemy/sleepy_harper_projectile.tscn").instantiate()
				proj.position=position
				proj.up_direction_variant=projectile_count%5
				get_tree().current_scene.add_child(proj)
				
				projectile_count+=1


func _on_shoot_timer_timeout() -> void:
	shootOnce=false
	$AnimatedSprite2D.play("sleepy")
	$pause_timer.start()
	projectile_count=0


func _on_pause_timer_timeout() -> void:
	$shoot_timer.start()
	$AnimatedSprite2D.play("playing")
	
