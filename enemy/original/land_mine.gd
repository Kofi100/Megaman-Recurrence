extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _on_player_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		$AnimatedSprite2D.play("setBomb")


func _on_animated_sprite_2d_animation_finished() -> void:
	var explosion = preload("res://enemy/boss/count_bomb_explosion_radius.tscn").instantiate()
	add_child(explosion)
	explosion.global_position = global_position
	explosion.parent = self
	#exp.scale = Vector2(0.5, 0.5)
