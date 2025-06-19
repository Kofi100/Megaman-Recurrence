extends enemy
var shootOnce:bool=false
var originalPos
func _ready() -> void:
	
	health=2
	playerdamagevalue=1
	originalPos=Vector2(global_position.x,Player.playerCharacter.global_position.y)
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
		global_position.y=Player.playerCharacter.global_position.y
	elif distance_x>=0:
		global_position.x=global_position.x-250
		global_position.y=Player.playerCharacter.global_position.y
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
	spawn_collectables()
	if (global_position==originalPos):
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
		if $AnimatedSprite2D.frame:
			if shootOnce==false:
				var proj=preload("res://enemy/sleepy_harper_projectile.tscn").instantiate()
				proj.position=position
				get_tree().current_scene.add_child(proj)
				shootOnce=true
		#else:shootOnce=false

func _on_shoot_projectile_timeout() -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_animated_sprite_2d_frame_changed() -> void:
	shootOnce=false
