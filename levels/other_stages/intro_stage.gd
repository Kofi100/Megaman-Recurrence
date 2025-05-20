extends Node2D
func _physics_process(delta: float) -> void:
	$GPUParticles2D.global_position.x=$megaman/player_camera.global_position.x+250#Vector2(250,0)
