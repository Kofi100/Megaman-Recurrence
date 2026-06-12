extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_stopped():
		var current_scene=get_tree().get_current_scene()
		#var enemy_projectiles=current_scene.get_nodes_in_group("enemy_Projectile")
		#if enemy_projectiles:
			#for projectile:Node in enemy_projectiles:
				#if is_instance_valid(projectile):
					#projectile.queue_free()
