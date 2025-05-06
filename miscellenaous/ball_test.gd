extends CharacterBody2D
var speed=250

func _ready() -> void:
	velocity=Vector2(-200,-200).normalized()*speed
func _physics_process(delta: float) -> void:
	var collision=move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())
	
