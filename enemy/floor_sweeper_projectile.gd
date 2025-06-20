extends enemy
func _ready() -> void:
	playerdamagevalue=3
	
	

func _physics_process(delta: float) -> void:
	match state:
		"left":
			velocity.x=-8000*delta
		"right":
			velocity.x=8000*delta
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
