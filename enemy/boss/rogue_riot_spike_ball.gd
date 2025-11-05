extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var bounce_count:int=5
func _ready() -> void:
	velocity.x=-30
	velocity.y=-10

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var collision=move_and_collide(velocity*delta)
	if collision:
		var bounce_velocity=velocity.bounce(collision.get_normal())
		#20% energy loss,80% kept
		velocity=bounce_velocity*0.9
		bounce_count-=1
	
	if bounce_count==0:
		queue_free()
	#move_and_slide()
