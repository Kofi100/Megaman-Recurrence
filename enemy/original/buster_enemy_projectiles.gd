extends enemy


const SPEED = 5000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	playerdamagevalue=4
	velocity.y=SPEED*delta
	if is_on_floor():
		queue_free()
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
