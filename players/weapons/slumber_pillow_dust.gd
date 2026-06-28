extends Node2D
var enemy_array:Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	await get_tree().create_timer(.2).timeout
	$Area2D/CollisionShape2D.call_deferred("set_disabled",false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	for e in enemy_array:
		if is_instance_valid(e):
			e.process_mode=(Node.PROCESS_MODE_DISABLED)
	scale+=Vector2(.25,.25)*delta
func _exit_tree() -> void:
	for e in enemy_array:
		if is_instance_valid(e):
			e.process_mode=(Node.PROCESS_MODE_INHERIT)

func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	if area.is_in_group("enemy") and not area.is_in_group("enemy_Projectile"):
		var enemy_body=area.get_parent()
		if not enemy_array.has(enemy_body):
			enemy_array.push_front(enemy_body)
		


func _on_life_timer_timeout() -> void:
	queue_free()
