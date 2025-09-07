extends enemy
var playerAround=false
func _ready() -> void:
	get_enemy_stats()
	$AnimatedSprite2D.play("idle")
	#var temp_health=float(CsvManager.get_data("punk_riot","health",CsvManager.ENEMY_DATA_PATH))
	health=2#float(stats["health"])#CsvManager.get_data("punk_riot","health",CsvManager.ENEMY_DATA_PATH)
	#var temp_damage=float(CsvManager.get_data("punk_riot","playerdamagevalue",CsvManager.ENEMY_DATA_PATH))
	playerdamagevalue=2#float(stats["playerdamagevalue"])#CsvManager.get_data("punk_riot","playerdamagevalue",CsvManager.ENEMY_DATA_PATH)
	#print([health,playerdamagevalue])
var proj:enemy
var shootOnce:bool=false
var shootRandomizer:int=0
var shootRandomizeOnce:bool=false
func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	hurtFlash($AnimatedSprite2D)
	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
	if distance_x<0:
		$AnimatedSprite2D.flip_h=false
	elif distance_x>=0:
		$AnimatedSprite2D.flip_h=true
	if not is_on_floor():
		velocity+=get_gravity()*delta
	if $AnimatedSprite2D.animation=="shoot":
		if shootRandomizeOnce==false:
			shootRandomizer=randi_range(0,2)
			shootRandomizeOnce=true
		if $AnimatedSprite2D.frame==3 or $AnimatedSprite2D.frame==6 or $AnimatedSprite2D.frame==9:#match $AnimatedSprite2D.frame:
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
						if shootRandomizer==0:
							match $AnimatedSprite2D.frame:
								3:proj.miniState=1
								6:proj.miniState=2
								9:proj.miniState=3
						elif shootRandomizer==1:
							match $AnimatedSprite2D.frame:
								3:proj.miniState=3
								6:proj.miniState=1
								9:proj.miniState=2
						elif shootRandomizer==2:
							match $AnimatedSprite2D.frame:
								3:proj.miniState=2
								6:proj.miniState=3
								9:proj.miniState=1
					$shoot.play()
					shootOnce=true
		else:
			shootOnce=false
	elif $AnimatedSprite2D.animation=="idle":
		shootRandomizeOnce=false
	move_and_slide()



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
