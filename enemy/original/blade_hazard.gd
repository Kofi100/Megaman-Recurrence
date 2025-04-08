extends CharacterBody2D
class_name FanHazard

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var isActive:bool=true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	if isActive:
		rotate(9*delta)
	elif !isActive:
		rotate(0*delta)
		

	move_and_slide()
