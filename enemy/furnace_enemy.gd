extends CharacterBody2D


func _on_throw_down_timer_timeout() -> void:
	if $coolDownTimer.is_stopped():
		var proj=preload("res://enemy/furnace_enemy_steel.tscn").instantiate()
		get_parent().add_child(proj)
		proj.global_position=global_position
		$coolDownTimer.start()
	#await get_tree().create_timer(15).timeout


func _on_cool_down_timer_timeout() -> void:
	$throwDownTimer.start()
