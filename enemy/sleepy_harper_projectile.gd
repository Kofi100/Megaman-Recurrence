extends enemy
var foundPlayer:bool=false
func _ready() -> void:
	playerdamagevalue=2
	

func _physics_process(delta: float) -> void:
	calculate_player_distance()
	if not foundPlayer:
		if distance_x<0:
			velocity.x=-1500*delta
		elif distance_x>=0:
			velocity.x=1500*delta
		velocity.y=randi_range(-1000,1000)*delta
		$AnimatedSprite2D.frame=randi_range(0,4)
		foundPlayer=true
	
	move_and_slide()
	#if not $VisibleOnScreenNotifier2D.is_on_screen():
		#pass
		#queue_free()
	#match state:
		#"left"


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass
