extends CanvasLayer
var selection_Index:int=0
var options_Screen
var onAnotherMenu:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().set_pause(false)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if onAnotherMenu==false:
		if Input.is_action_just_pressed("move_up"):
			selection_Index-=1
		elif Input.is_action_just_pressed("move_down"):
			selection_Index+=1
	if selection_Index<0:
		selection_Index=3
	elif selection_Index>3:
		selection_Index=0
	match selection_Index:
		0:
			$Arrow.global_position=$debug.global_position-Vector2(20,0)
		1:
			$Arrow.global_position=$"restart level".global_position-Vector2(20,0)
		2:
			$Arrow.global_position=$options.global_position-Vector2(20,0)
		#2:
			#$Arrow.global_position=$exit.global_position-Vector2(10,0)
			
	if selection_Index!=3:
		$Arrow.visible=true
		$move_HUDbtn.play("notSelected")
	else:
		$Arrow.visible=false
		$move_HUDbtn.play("selected")
	if Input.is_action_just_pressed("shoot") and onAnotherMenu==false:
		match selection_Index:
			0:
				get_tree().set_pause(false)
				get_tree().change_scene_to_file("res://levels/main_menu.tscn")
			1:
				get_tree().set_pause(false)
				get_tree().reload_current_scene()
			2:
				if options_Screen==null and onAnotherMenu==false:
					options_Screen=preload("res://levels/menu_options.tscn").instantiate()
					add_child(options_Screen)
					#options_Screen.z_index=2
					onAnotherMenu=true
					options_Screen.connect("tree_exiting",leavingOtherScreen)# to connect to custom function to detect deletion:work on it later
			3:
				queue_free()
				
func _input(event: InputEvent) -> void:
	#if event is In
	pass
#func leavingOtherS
func leavingOtherScreen():
	onAnotherMenu=false
func _on_tree_exiting() -> void:
	#if get_parent():
		#var parent=get_parent()
		#print(parent.name)
		#if "screen2" in parent:
			#parent.screen2=null
	pass
