extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	pass
	playerdamagevalue=7
	if velocity.y>0:
		$AnimatedSprite2D.play("active")
	elif velocity.y<0:
		$AnimatedSprite2D.play_backwards("active")
	elif velocity.y==0:
		$AnimatedSprite2D.stop()
