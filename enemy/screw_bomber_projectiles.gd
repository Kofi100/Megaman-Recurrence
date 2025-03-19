extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var enemyVariant: String = "none"

func _physics_process(delta: float) -> void:
	playerdamagevalue = 2
	#all movement instances of screw bomber's projectiles
	match state:
		0:
			velocity = Vector2(-5000, -5000) * delta
		1:
			velocity = Vector2(0, -5000) * delta
		2:
			velocity = Vector2(5000, -5000) * delta
		3:
			#velocity = Vector2(-7500, -5000) * delta
			velocity=Vector2(-5000,0)*delta
		4:
			#velocity = Vector2(7500, -5000) * delta
			velocity=Vector2(5000,0)*delta
	match enemyVariant:
		"none":
			$Sprite2D.frame=0
		"ice":
			$Sprite2D.frame=1
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
