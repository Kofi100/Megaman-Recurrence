extends enemy


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var direction="left"
func _ready() -> void:
	playerdamagevalue=3
	$AnimatedSprite2D.play("punch_proj")
	match direction:
		"left":
			velocity.x=-SPEED
		"right":
			velocity.x=SPEED

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.flip_h=false if direction=="right" else true

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
