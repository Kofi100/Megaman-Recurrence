extends enemy
var playerAround=false
func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	health=5
	playerdamagevalue=3
var proj:enemy
var shootOnce:bool=false
func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	if distance_x<0:
		$AnimatedSprite2D.flip_h=false
	elif distance_x>=0:
		$AnimatedSprite2D.flip_h=true
	if not is_on_floor():
		velocity+=get_gravity()*delta
	if $AnimatedSprite2D.animation=="shoot":
		if $AnimatedSprite2D.frame==2 or $AnimatedSprite2D.frame==5 or $AnimatedSprite2D.frame==8:#match $AnimatedSprite2D.frame:
			#2,5,8:
				if shootOnce==false:
					proj=preload("res://enemy/punk_riot_projectile.tscn").instantiate()
					#proj.position=position
					get_parent().add_child(proj)
					#proj.global_position=global_position
					if proj!=null:
						if $AnimatedSprite2D.flip_h==false:
							proj.global_position=$shootPos_L.global_position
							proj.state="left"
							
						elif $AnimatedSprite2D.flip_h==true:
							proj.global_position=$shootPos_R.global_position
							proj.state="right"
						match $AnimatedSprite2D.frame:
							2:proj.miniState=1
							5:proj.miniState=2
							8:proj.miniState=3
					shootOnce=true
		else:
			shootOnce=false



func _on_player_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		#if $player_Detect/CollisionShape2D.disabled==false:
			#$pla
		if playerAround==false :#and $timer/Timer.is_stopped()
			$player_Detect/CollisionShape2D.set_deferred("disabled",true)
			$AnimatedSprite2D.play("shoot")
			playerAround=true


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"shoot":
			$AnimatedSprite2D.play("idle")
			
			playerAround=false
			$timer/Timer.start()


func _on_timer_timeout() -> void:
	$player_Detect/CollisionShape2D.set_deferred("disabled",false)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
