extends Node2D
var menuOption:int=0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		menuOption-=1
	elif Input.is_action_just_pressed("move_down"):
		menuOption+=1
	
	match menuOption:
		0:
			$SelectArrow.set_global_position($"allMarkers/0".global_position-Vector2(20,0))
		1:
			$SelectArrow.set_global_position($"allMarkers/1".global_position-Vector2(20,0))
		2:
			$SelectArrow.set_global_position($"allMarkers/2".global_position-Vector2(20,0))
	if Input.is_action_just_pressed("pause"):
		match menuOption:
			0:get_tree().change_scene_to_file("res://levels/challenges/challenge_level_one.tscn")
			1:get_tree().change_scene_to_file("res://levels/challenges/challenge_level_two.tscn")
			2:get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")
