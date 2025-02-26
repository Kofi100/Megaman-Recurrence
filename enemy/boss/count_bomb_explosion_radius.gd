extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var parent: Node


func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$explosion.play()


func _physics_process(delta: float) -> void:
	playerdamagevalue = 5
	#enables the hitbox on frames 8-10 and disables it on other frames
	if $AnimatedSprite2D.frame >= 8 and $AnimatedSprite2D.frame <= 10:
		$bombRadius/CollisionShape2D.disabled = false
	else:
		$bombRadius/CollisionShape2D.disabled = true


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	if parent:
		parent.queue_free()
