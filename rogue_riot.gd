extends enemy
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	calculate_player_distance()
	#print($AnimatedSprite2D.animation)
	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
	if distance_x<0:
		$AnimatedSprite2D.flip_h=false
	elif distance_x>=0:
		$AnimatedSprite2D.flip_h=true
	move_and_slide()
