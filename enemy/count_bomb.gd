extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var activateBomb = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _on_switch_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hitbox"):
		$AnimatedSprite2D.play("activate")


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"activate":
			$AnimatedSprite2D.play("explode")
		"explode":
			#$AnimatedSprite2D.visible = false
			var explosion = preload("res://enemy/boss/mm3_to_10_explosion_radius.tscn").instantiate()
			add_child(explosion)
			explosion.global_position = global_position
			explosion.parent = self


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
