extends enemy

var SPEED = 5000.0
@export var direction: String = "left"


func _physics_process(delta: float) -> void:
	playerdamagevalue = 8
	match direction:
		"left":
			velocity.x = -SPEED * delta
		"right":
			velocity.x = SPEED * delta
	move_and_slide()
	if not $VisibleOnScreenNotifier2D.is_on_screen():
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
