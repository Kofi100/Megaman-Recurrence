extends CharacterBody2D
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity=Vector2(0,70)
	var collision=move_and_collide(velocity*delta)
