extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction:String="left"
func _ready() -> void:
	$AnimatedSprite2D.play("default")
func _physics_process(delta: float) -> void:
	playerdamagevalue=4
	if $AnimatedSprite2D.frame==3:
		rotate(0.3*delta)
		match direction:
			"left":
				velocity.x-=2000*delta
			"right":
				velocity.x+=2000*delta

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
