extends enemy
var setDirection:bool=false
func _ready() -> void:
	$AnimatedSprite2D.play("flying")
	health=3
func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	playerdamagevalue=3
	$bomb_Timer.wait_time=.7
	if not setDirection:
		if distance_x<0:
			velocity.x=-40
		elif distance_x>=0:
			velocity.x=40
		setDirection=true
	
	if velocity.x<0:
		$AnimatedSprite2D.flip_h=false
	elif velocity.x>=0:
		$AnimatedSprite2D.flip_h=true
	move_and_collide(velocity*delta)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_bomb_timer_timeout() -> void:
	var bomb=preload("res://enemy/batallion_balloon_bomb.tscn").instantiate()
	bomb.global_position=$bombSpawnMarker2D.global_position
	get_parent().add_child(bomb)
