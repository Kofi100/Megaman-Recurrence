extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	playerdamagevalue = 1

	move_and_slide()
