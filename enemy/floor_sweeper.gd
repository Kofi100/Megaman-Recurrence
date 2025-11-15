extends enemy

func _ready() -> void:
	pass
	playerdamagevalue=3
	health=3
	
func _physics_process(_delta: float) -> void:
	$Timer.wait_time=2
	spawn_collectables()
	calculate_player_distance()

func _on_timer_timeout() -> void:
	var proj=preload("res://enemy/floor_sweeper_projectile.tscn").instantiate()
	var proj2=preload("res://enemy/floor_sweeper_projectile.tscn").instantiate()
	proj.state="left";proj2.state="right"
	proj.position=position-Vector2(0,10);proj2.position=position-Vector2(0,10)
	get_tree().current_scene.add_child(proj)
	get_tree().current_scene.add_child(proj2)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
