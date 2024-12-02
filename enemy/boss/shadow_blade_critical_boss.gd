extends enemy


var SPEED = 10000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var angle_to_shoot:float
func _ready():
	$ShadowBlade.play()
func _physics_process(delta):
	playerdamagevalue=5
	velocity.y=sin(angle_to_shoot)*SPEED*delta
	velocity.x=cos(angle_to_shoot)*SPEED*delta
	
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
