extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	playerdamagevalue=5
	rotate(0.5*delta)
	velocity.x=-8000*delta
	move_and_slide()
