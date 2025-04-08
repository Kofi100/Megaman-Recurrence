extends Node2D
var MenuOptionNo: int = 0
var menuPoppedUp:bool=false
#avoid using float values when crating menus:it has a weird gimmick with match statements
#causing the statements not to work.
@onready var menu_Items=$ScrollContainer/VBoxContainer.get_children()
var options
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$main_Menu_BGM.play()
	$ScrollContainer.ensure_control_visible(menu_Items[MenuOptionNo])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if menuPoppedUp==true:
		MenuOptionNo=4
	match MenuOptionNo:
		0:
			$SelectArrow.global_position=Vector2($ScrollContainer/VBoxContainer/start.global_position.x - 20, $ScrollContainer/VBoxContainer/start.global_position.y)
		1:
			$SelectArrow.global_position.x=$ScrollContainer/VBoxContainer/tutorial.global_position.x - 20
			$SelectArrow.global_position.y= $ScrollContainer/VBoxContainer/tutorial.global_position.y
		2:
			$SelectArrow.global_position=(Vector2($ScrollContainer/VBoxContainer/debug.global_position.x - 20, $ScrollContainer/VBoxContainer/debug.global_position.y))
		3:
			$SelectArrow.global_position=(Vector2($ScrollContainer/VBoxContainer/change_Controls.global_position.x - 20, $ScrollContainer/VBoxContainer/change_Controls.global_position.y))
		4:$SelectArrow.global_position=$ScrollContainer/VBoxContainer/options.global_position-Vector2(20,0)
		5:$SelectArrow.global_position=(Vector2($ScrollContainer/VBoxContainer/quit.global_position.x - 20, $ScrollContainer/VBoxContainer/quit.global_position.y))

	if Input.is_action_just_pressed("shoot"):
		#print("pressed")
		match MenuOptionNo:
			0:
				get_tree().change_scene_to_file("res://levels/robot_master_menu.tscn")
			1:
				get_tree().change_scene_to_file("res://levels/other_stages/tutorial_stage.tscn")
			2:
				get_tree().change_scene_to_file("res://levels/main_menu.tscn")
			3:
				get_tree().change_scene_to_file("res://levels/input_rebind_menu.tscn")
			4:
				#dont declare options here
				if menuPoppedUp==false:
					options=preload("res://levels/menu_options.tscn").instantiate()
					get_parent().add_child(options)
					menuPoppedUp=true
				elif menuPoppedUp==true:
					if options!=null:
						options.queue_free()
					menuPoppedUp=false
			5:get_tree().quit(0)



func _input(event: InputEvent) -> void:

	if event is InputEventAction or event is InputEventKey:
		if event.is_action_pressed("move_up"):
			#MenuOptionNo -= 1
			MenuOptionNo = max(MenuOptionNo - 1, 0)
			$change_Option_SFX.play()
			$ScrollContainer.ensure_control_visible(menu_Items[MenuOptionNo])
		elif event.is_action_pressed("move_down"):
			#MenuOptionNo += 1
			$change_Option_SFX.play()
			MenuOptionNo = min(MenuOptionNo + 1, menu_Items.size() - 1)
			$ScrollContainer.ensure_control_visible(menu_Items[MenuOptionNo])
			
		
		MenuOptionNo = clampi(MenuOptionNo, 0, 5)
