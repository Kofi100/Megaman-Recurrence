extends Node2D
var menuIndex:int=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$arrowBlinkTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		menuIndex-=1
	elif Input.is_action_just_pressed("move_down"):
		menuIndex+=1
	menuIndex=clampi(menuIndex,0,2)
	match menuIndex:
		0:$SelectArrow.set_global_position($saveGame.global_position-Vector2(20,0))
		1:$SelectArrow.set_global_position($continue.global_position-Vector2(20,0))
		2:$SelectArrow.set_global_position($quit.global_position-Vector2(20,0))
	if Input.is_action_just_pressed("shoot"):
		match menuIndex:
			0:
				pass
			1:
				get_tree().change_scene_to_file("res://levels/robot_master_menu.tscn")
			2:
				get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")


func _on_arrow_blink_timer_timeout() -> void:
	$SelectArrow.visible=!$SelectArrow.visible
