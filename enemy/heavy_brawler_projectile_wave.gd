extends enemy


const SPEED = 140.0
const JUMP_VELOCITY = -400.0
var direction="left"

func _ready() -> void:
	playerdamagevalue=4
	$AnimatedSprite2D.play("stomp_proj")
	match direction:
		"left":
			velocity.x=-SPEED
		"right":
			velocity.x=SPEED

func _physics_process(delta: float) -> void:
	## Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	$AnimatedSprite2D.flip_h=false if direction=="right" else true
	if is_on_wall():
		queue_free()



	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
