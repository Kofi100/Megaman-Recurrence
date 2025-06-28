extends enemy
var speed=10000
func _ready() -> void:
	playerdamagevalue=3
	calculate_player_distance()
	if distance_x<0:
		state="left"
	elif distance_x>=0:
		state="right"

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("default")
	match state:
		"left":
			$AnimatedSprite2D.flip_h=false
			velocity.x=-speed*delta
		"right":
			$AnimatedSprite2D.flip_h=true
			velocity.x=speed*delta
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
