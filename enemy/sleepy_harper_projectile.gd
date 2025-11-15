extends enemy
var foundPlayer:bool=false
func _ready() -> void:
	playerdamagevalue=2
	health=1
func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	if health<=0:
		GlobalScript.spawn_collectable_no=100
	if not foundPlayer:
		if distance_x<0:
			velocity.x=-2200*delta
		elif distance_x>=0:
			velocity.x=2200*delta
		velocity.y=randi_range(-1500,1500)*delta
		$AnimatedSprite2D.frame=randi_range(0,4)
		foundPlayer=true
	
	move_and_slide()
	#if not $VisibleOnScreenNotifier2D.is_on_screen():
		#pass
		#queue_free()
	#match state:
		#"left"
	#delete upon screen transitioning
	if not GlobalScreenTransitionTimer.is_stopped():
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles"):
		#queue_free()
		pass
		
