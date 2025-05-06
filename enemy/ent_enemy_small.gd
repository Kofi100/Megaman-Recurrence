extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction=false

func _ready() -> void:
	pass
	$Timer.start()
	$Timer/move_Duration_Timer.start()
	$vineAttackTemplate/CollisionShape2D.set_deferred("disabled",true)
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	calculate_player_distance()
	spawn_collectables()#might deactivate later during testing
	if $Timer/move_Duration_Timer.is_stopped()==false:
		if direction==true:
			velocity.x=-500*delta
		elif direction==false:
			velocity.x=500*delta
	else:
		velocity.x=0
		
	if abs(distance_x)<50:
		$Timer/move_Duration_Timer.stop()
		$Timer.stop()
		$Timer/move_CoolDown_Timer.stop()
		$vineAttackTemplate/CollisionShape2D.set_deferred("disabled",false)
	elif  $Timer/move_Duration_Timer.is_stopped():
		$Timer/move_Duration_Timer.start()
		$Timer.start()
		$vineAttackTemplate/CollisionShape2D.set_deferred("disabled",true)

	move_and_slide()


func _on_timer_timeout() -> void:
	direction=!direction


func _on_move_duration_timer_timeout() -> void:
	$Timer/move_CoolDown_Timer.start()
	$Timer.stop()


func _on_move_cool_down_timer_timeout() -> void:
	$Timer.start()
	$Timer/move_Duration_Timer.start()
