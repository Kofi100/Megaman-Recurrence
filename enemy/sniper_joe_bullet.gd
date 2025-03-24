extends enemy

@export_category("Variables")
@export var SPEED = 5500  #14000.0
const JUMP_VELOCITY = -400.0
var direction = "left"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	playerdamagevalue = 4


func _physics_process(delta):
	SPEED = 5100
	match direction:
		"left":
			velocity.x = -SPEED * delta
		"right":
			velocity.x = SPEED * delta

	move_and_slide()


func _on_hitbox_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("tilemaps"):
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
