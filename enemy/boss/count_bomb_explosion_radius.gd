extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var parent:Node
func _ready() -> void:
	$AnimatedSprite2D.play("default")
func _physics_process(delta: float) -> void:
	playerdamagevalue=5


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	if parent:
		parent.queue_free()
