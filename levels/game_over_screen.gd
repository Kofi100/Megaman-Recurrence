extends Node2D
var menuOption = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		menuOption -= 1
	elif Input.is_action_just_pressed("move_down"):
		menuOption += 1
	match menuOption:
		0:
			$selectionRect.global_position = $continue.global_position
		1:
			$selectionRect.global_position = $robot_Master.global_position
		2:
			$selectionRect.global_position = $exit.global_position
	if Input.is_action_just_pressed("shoot"):
		match menuOption:
			0:
				get_tree().change_scene_to_file(GlobalScript.lastStageEntered)
			1:
				get_tree().change_scene_to_file("res://levels/robot_master_menu.tscn")
			2:
				get_tree().quit(0)
