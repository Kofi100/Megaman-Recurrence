extends enemy

@export var SPEED = 20000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var angle: float
var angleSet = false


func _ready() -> void:
	$AnimatedSprite2D.play("ready")
	$shootTimer.start()
	#global_position.y=global_position.y+30


func _physics_process(delta: float) -> void:
	playerdamagevalue = 5
	if angleSet == true:
		velocity.y = sin(angle) * SPEED * delta
		velocity.x = cos(angle) * SPEED * delta
		move_and_slide()


func _on_timer_timeout() -> void:
	pass


func _on_shoot_timer_timeout() -> void:
	var distanceX = GlobalScript.playerposx - global_position.x
	var distanceY = GlobalScript.playerposy - global_position.y
	angle = atan2(distanceY, distanceX)
	angleSet = true
	$AnimatedSprite2D.play("fire")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
