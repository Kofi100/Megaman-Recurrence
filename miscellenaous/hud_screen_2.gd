extends CanvasLayer
var selection_Index:int=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().set_pause(false)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		selection_Index-=1
	elif Input.is_action_just_pressed("move_down"):
		selection_Index+=1
	if selection_Index<0:
		selection_Index=2
	elif selection_Index>2:
		selection_Index=0
	match selection_Index:
		0:
			$Arrow.global_position=$debug.global_position-Vector2(10,0)
		1:
			$Arrow.global_position=$"restart level".global_position-Vector2(10,0)
		2:
			$Arrow.global_position=$exit.global_position-Vector2(10,0)
	if Input.is_action_just_pressed("shoot"):
		match selection_Index:
			0:
				get_tree().set_pause(false)
				get_tree().change_scene_to_file("res://levels/main_menu.tscn")
			1:
				get_tree().set_pause(false)
				get_tree().reload_current_scene()
			2:
				queue_free()
				
func _input(event: InputEvent) -> void:
	#if event is In
	pass


func _on_tree_exiting() -> void:
	#if get_parent():
		#var parent=get_parent()
		#print(parent.name)
		#if "screen2" in parent:
			#parent.screen2=null
	pass
