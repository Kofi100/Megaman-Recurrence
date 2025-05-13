extends Node2D
var save_keybinds_path = "res://keybinds.txt"
var save_padbinds_path = "res://padbinds.txt"
@export var input_dictionary_keys = {
	"move_up": 0,
	"move_down": 0,
	"move_left": 0,
	"move_right": 0,
	"jump": 0,
	"dash": 0,
	"shoot": 0,
	"pause": 0,
	"switch_weapon_left": 0,
	"switch_weapon_right": 0,
}
#@export var node_to_action = {0: null, 1: null, 2: null, 3: null, 4: null, 5: null, 6: null, 7: null, 8: null, 9: null}
@export var option_to_action_dict = {
	0: "move_up", 1: "move_down", 2: "move_left", 3: "move_right", 4: "jump", 5: "dash", 6: "shoot", 7: "pause", 8: "switch_weapon_left", 9: "switch_weapon_right"
}

var menuOption: int = 0
var inputAccept:bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_keys_to_players()
	#$Control/ScrollContainer/VSplitContainer/up_btn.grab_focus()
	$mega_spin.play("spinnnn")
	inputAccept=false
	#creates a weird loop of sorts...
	#while true:
		#if Input.is_action_just_released("shoot"):
			#inputAccept=false
			#await get_tree().create_timer(2).timeout
			#inputAccept=true


var display_label = false
var selected_option: int = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_tree().paused=false
	$waiting_text_label.visible = display_label
	$waiting_text_BG_Color_Rect.visible=display_label
	if Input.is_action_just_pressed("die_debug") and display_label == true:
		display_label = false
	#display_label_fxn()
	if Input.is_action_just_pressed("move_up"):
		menuOption -= 1
	elif Input.is_action_just_pressed("move_down"):
		menuOption += 1
	elif Input.is_action_just_pressed("move_left"):
		menuOption = 7
	elif Input.is_action_just_pressed("move_right"):
		menuOption = 7
	#match menuOption:
		#0:
			#$Control/ScrollContainer/VSplitContainer/up_btn.grab_focus()
		#1:
			#$Control/ScrollContainer/VSplitContainer/down_btn.grab_focus()
		#2:
			#$Control/ScrollContainer/VSplitContainer/left_btn.grab_focus()
		#3:
			#$Control/ScrollContainer/VSplitContainer/right_btn.grab_focus()
		#4:
			#$Control/ScrollContainer/VSplitContainer/jump_btn.grab_focus()
		#5:
			#$Control/ScrollContainer/VSplitContainer/dash_btn.grab_focus()
		#6:
			#$Control/ScrollContainer/VSplitContainer/shoot_btn.grab_focus()
		#7:
			#$main_menu.grab_focus()
	match menuOption:
		0:$selectArrow.set_global_position($keyboard_Settings/up.global_position-Vector2(20,0))
		1:$selectArrow.set_global_position($keyboard_Settings/down.global_position-Vector2(20,0))
		2:$selectArrow.set_global_position($keyboard_Settings/left.global_position-Vector2(20,0))
		3:$selectArrow.set_global_position($keyboard_Settings/right.global_position-Vector2(20,0))
		4:$selectArrow.set_global_position($keyboard_Settings/jump.global_position-Vector2(20,0))
		5:$selectArrow.set_global_position($keyboard_Settings/dash.global_position-Vector2(20,0))
		6:$selectArrow.set_global_position($keyboard_Settings/shoot.global_position-Vector2(20,0))
		7:$selectArrow.set_global_position($main_menu.global_position-Vector2(20,0))
	if Input.is_action_just_released("shoot") and inputAccept==true:
		if menuOption>=0 and menuOption<=6:
			display_label_fxn()
			selected_option=menuOption
			#if display_label == false:
				#display_label = true
			#elif display_label == true:
				#display_label = false
		if menuOption==7:
			get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")
		#0:$selectArrow.set_global_position($keyboard_Settings/up.global_position-Vector2(20,0))

var action_to_get


func _input(event):
	if inputAccept==false:
		display_label=false
		return
	if display_label == true:
		if event is InputEventKey and event.keycode!=27:
			if InputMap.has_action(option_to_action_dict[selected_option]) and event.is_released() == true:
				action_to_get = option_to_action_dict[selected_option]
				for i in InputMap.action_get_events(action_to_get):  #input_dictionary_keys
					if i is InputEventKey:
						print(i)
						InputMap.action_erase_event(action_to_get, i)  #REMOVE ALL INPUT KEYS FOR ACTION EVENT
						InputMap.action_add_event(action_to_get, event)  #ADD THE NEW KEY TO THE ACTION EVENT IN INPUT MAP
						print("previous keybind deleted, added new key:", OS.get_keycode_string(event.keycode))
						save_keybinds(event)
						display_label = false
				#InputMap.era

	#if event== InputEventMouse.set_button_mask(1):
	#var left_mouse = InputEventMouseButton.new()
	#left_mouse.button_mask = 1
	##Button masks detect which button got pressed/released last
	##eg. "1" is the Left Mouse Button
	#if event is InputEventMouseButton:  #if Input Event is any Mouse button,
		##print("Input Event:(MouseButton not Gesture)::",event.pressed)
		#if event.pressed == true:  #and event.button_mask==left_mouse.button_mask:
			##and I have pressed  the button
			##if event ==InputEventMouseButton:
			##if  event.is_action_released()
			##print("yessssss,left button pressed")
			##set display_label to false therefore deactivating the input change request.
			#display_label = false
		if Input.is_action_just_pressed("die_debug"):
			display_label=false


func save_keybinds(key):  #This saves the keycode of the key you pressed into a file.
	if key is InputEventKey:
		input_dictionary_keys[action_to_get] = key.keycode

		var file_open = FileAccess.open(save_keybinds_path, FileAccess.WRITE)
		if file_open.is_open() == true:
			print("\n file opened")
		if file_open != null:
			file_open.store_string(str(input_dictionary_keys))
			print("\n file stored input dictionary")
			file_open.close()
			print("\n input keybinds saved successfully 🥳")


func save_padbinds(padEvent):  #This saves the keycode of the key you pressed into a file.
	if padEvent is InputEventJoypadButton or InputEventJoypadMotion:
		if padEvent is InputEventJoypadButton:
			input_dictionary_keys[action_to_get] = padEvent.button_index
		elif padEvent is InputEventJoypadMotion:
			input_dictionary_keys[action_to_get] = padEvent.axis_value

		var file_open = FileAccess.open(save_padbinds_path, FileAccess.WRITE)
		if file_open.is_open() == true:
			print("\n file opened")
		if file_open != null:
			file_open.store_string(str(input_dictionary_keys))
			print("\n file stored input dictionary")
			file_open.close()
			print("\n input Gamepad Keybinds: Saved successfully 🥳")


func set_keys_to_players():
	var file_set = FileAccess.open(save_keybinds_path, FileAccess.READ)
	if file_set != null:
		print(name, " --> opened keybind save file successfully")  #.is_open()
	if file_set != null:
		var keybinds_as_dict = str_to_var(file_set.get_line())
		print("saved keybinds_as_dict: ", keybinds_as_dict)
		if keybinds_as_dict != null:
			for i in keybinds_as_dict:
				if input_dictionary_keys.has(i) and keybinds_as_dict[i] != 0 and keybinds_as_dict[i] != null:
					input_dictionary_keys[i] = keybinds_as_dict[i]
					print("input_dictionary_keys->[", i, "] :", input_dictionary_keys[i])

					var new_InputKey = InputEventKey.new()
					new_InputKey.keycode = keybinds_as_dict[i]
					if InputMap.has_action(i):
						for prevkeys in InputMap.action_get_events(i):
							if prevkeys is InputEventKey:
								InputMap.action_erase_event(i, prevkeys)
								InputMap.action_add_event(i, new_InputKey)
								print("\n newKey set:action:", i, "->", OS.get_keycode_string(new_InputKey.keycode))
		elif keybinds_as_dict == null:
			print(name, "-> keybinds_as_dict:null: creating new file...")
			var file_open = FileAccess.open(save_keybinds_path, FileAccess.WRITE)
			if file_open.is_open() == true:
				print("\n file opened")
			if file_open != null:
				file_open.store_string(str(input_dictionary_keys))
				print("\n file stored input dictionary")
				file_open.close()
				print("\n input keybinds saved successfully 🥳")

	elif file_set == null:
		print("file_set:null: creating new file...")
		var file_open = FileAccess.open(save_keybinds_path, FileAccess.WRITE)
		if file_open.is_open() == true:
			print("\n file opened")
		if file_open != null:
			file_open.store_string(str(input_dictionary_keys))
			print("\n file stored input dictionary")
			file_open.close()
			print("\n input keybinds saved successfully 🥳")


func display_label_fxn():
	if display_label == false:
		display_label = true
		$waiting_text_BG_Color_Rect.visible=true
		return
	elif display_label == true:
		display_label = false
		$waiting_text_BG_Color_Rect.visible=false
		return


func _on_up_btn_pressed():
	selected_option = 0


func _on_down_btn_pressed():
	pass  # Replace with function body.
	selected_option = 1


func _on_left_btn_pressed():
	pass  # Replace with function body.
	selected_option = 2


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")#("res://levels/main_menu.tscn")


func _on_right_btn_pressed():
	selected_option = 3


func _on_jump_btn_pressed():
	selected_option = 4


func _on_slide_btn_pressed():
	selected_option = 5


func _on_shoot_btn_pressed():
	selected_option = 6


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()


var inputmap: InputMap


func _on_button_pressed() -> void:
	var scene = PackedScene.new()
	#scene.pack(inputmap)
	##inputmap=InputMap.new()
	#ResourceSaver.save(inputmap,"res://")


func _on_delay_input_timer_timeout() -> void:
	inputAccept=true
