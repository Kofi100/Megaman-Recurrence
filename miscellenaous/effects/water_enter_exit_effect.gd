extends CharacterBody2D
func _ready() -> void:
	$water_splash_sfx.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
