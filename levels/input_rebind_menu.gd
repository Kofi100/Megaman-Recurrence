extends Node2D
var save_keybinds_path = "res://keybinds.txt"
var save_padbinds_path = "res://padbinds.txt"
@export_enum("move_up","move_down","move_left","move_right","jump","dash","shoot","pause","switch_weapon_left","switch_weapon_right")var InputAction="move_up"

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
@export var option_to_action_dict_GamePad = {
	10: "move_up", 11: "move_down", 12: "move_left", 13: "move_right", 14: "jump", 15: "dash", 16: "shoot", 17: "pause", 18: "switch_weapon_left", 19: "switch_weapon_right"
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
	menuOption=clampi(menuOption,0,20)
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
		menuOption+=10
	elif Input.is_action_just_pressed("move_right"):
		menuOption+=10

	match menuOption:
		0:$selectArrow.set_global_position($keyboard_Settings/up.global_position-Vector2(10,0))
		1:$selectArrow.set_global_position($keyboard_Settings/down.global_position-Vector2(10,0))
		2:$selectArrow.set_global_position($keyboard_Settings/left.global_position-Vector2(10,0))
		3:$selectArrow.set_global_position($keyboard_Settings/right.global_position-Vector2(10,0))
		4:$selectArrow.set_global_position($keyboard_Settings/jump.global_position-Vector2(10,0))
		5:$selectArrow.set_global_position($keyboard_Settings/dash.global_position-Vector2(10,0))
		6:$selectArrow.set_global_position($keyboard_Settings/shoot.global_position-Vector2(10,0))
		7:$selectArrow.set_global_position($keyboard_Settings/pause.global_position-Vector2(10,0))
		8:$selectArrow.set_global_position($keyboard_Settings/switchWeaponL.global_position-Vector2(10,0))
		9:$selectArrow.set_global_position($keyboard_Settings/switchWeaponR.global_position-Vector2(10,0))

		10:$selectArrow.set_global_position($gampad_Settings/up.global_position-Vector2(10,0))
		11:$selectArrow.set_global_position($gampad_Settings/down.global_position-Vector2(10,0))
		12:$selectArrow.set_global_position($gampad_Settings/left.global_position-Vector2(10,0))
		13:$selectArrow.set_global_position($gampad_Settings/right.global_position-Vector2(10,0))
		14:$selectArrow.set_global_position($gampad_Settings/jump.global_position-Vector2(10,0))
		15:$selectArrow.set_global_position($gampad_Settings/dash.global_position-Vector2(10,0))
		16:$selectArrow.set_global_position($gampad_Settings/shoot.global_position-Vector2(10,0))
		17:$selectArrow.set_global_position($gampad_Settings/pause.global_position-Vector2(10,0))
		18:$selectArrow.set_global_position($gampad_Settings/switchWeaponL.global_position-Vector2(10,0))
		19:$selectArrow.set_global_position($gampad_Settings/switchWeaponR.global_position-Vector2(10,0))
		
		20:$selectArrow.set_global_position($main_menu.global_position-Vector2(10,0))
	match menuOption:
		0,10:InputAction="move_up"
		1,11:InputAction="move_down"
		2,12:InputAction="move_left"
		3,13:InputAction="move_right"
		4,14:InputAction="jump"
		5,15:InputAction="dash"
		6,16:InputAction="shoot"
		7,17:InputAction="pause"
		8,18:InputAction="switch_weapon_left"
		9,19:InputAction="switch_weapon_right"
	
	if Input.is_action_just_released("shoot") and inputAccept==true:
		if menuOption>=0 and menuOption<=19:
			display_label_fxn()
			selected_option=menuOption
		if menuOption==20:
			get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")
		#0:$selectArrow.set_global_position($keyboard_Settings/up.global_position-Vector2(20,0))

#var action_to_get
var currentDeviceVar

func _input(event):
	#currentDeviceVar=event.get_device()
	#print(currentDeviceVar)
	if inputAccept==false:
		display_label=false
		return
	if display_label == true:
		if event is InputEventKey and event.keycode!=27:
			if InputMap.has_action(InputAction) and event.is_released() == true:
				#action_to_get = option_to_action_dict[selected_option]
				for i:InputEventKey in InputMap.action_get_events(InputAction):  #input_dictionary_keys
					#if i is InputEventKey:
					print(i)
					InputMap.action_erase_event(InputAction, i)  #REMOVE ALL INPUT KEYS FOR ACTION EVENT
					InputMap.action_add_event(InputAction, event)  #ADD THE NEW KEY TO THE ACTION EVENT IN INPUT MAP
					print("previous keybind deleted, added new key:", OS.get_keycode_string(event.keycode))
					save_keybinds(event)
					display_label = false
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			if InputMap.has_action(InputAction) and event.is_released():
				if event is InputEventJoypadMotion:
					for previousMotion:InputEventJoypadMotion in InputMap.action_get_events(InputAction):
						InputMap.action_erase_event(InputAction,previousMotion)
						print(previousMotion,":deleted")
					InputMap.action_add_event(InputAction,event)
					InputMap.action_set_deadzone(InputAction,0.2)
					print(event,":added with deadzone")
					save_padbinds(event)
					display_label=false
				if event is InputEventJoypadButton:
					for previousButton:InputEventJoypadButton in InputMap.action_get_events(InputAction):
						InputMap.action_erase_event(InputAction,previousButton)
						print(previousButton,":deleted")
					InputMap.action_add_event(InputAction,event)
					#InputMap.action_set_deadzone(InputAction,0.2)
					print(event,":added with deadzone")
					save_padbinds(event)
					display_label=false
			pass
			
				#InputMap.era
		if Input.is_action_just_pressed("die_debug"):
			display_label=false


func save_keybinds(key):  #This saves the keycode of the key you pressed into a file.
	if key is InputEventKey:
		input_dictionary_keys[InputAction] = key.keycode

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
			input_dictionary_keys[InputAction] = padEvent.button_index
		elif padEvent is InputEventJoypadMotion:
			input_dictionary_keys[InputAction] = padEvent.axis_value

		var file_open = FileAccess.open(save_padbinds_path, FileAccess.WRITE)
		if file_open.is_open() == true:
			print("\n file opened")
		if file_open != null:
			file_open.store_string(str(input_dictionary_keys))
			print("\n file stored input dictionary")
			file_open.close()
			print("\n input Gamepad Keybinds: Saved successfully 🥳")


func set_keys_to_players():
	var keyBoardSettingFile = FileAccess.open(save_keybinds_path, FileAccess.READ)
	#
	#if keyBoardSettingFile != null:
		  ##.is_open()
	
	if keyBoardSettingFile == null:
		print("keyBoardSettingFile:null: creating new file...")
		createNewFile(save_keybinds_path)
		return
	
	print(name, " --> opened keybind save file successfully")
	var keybinds_as_dict = str_to_var(keyBoardSettingFile.get_line())
	print("saved keybinds_as_dict: ", keybinds_as_dict)
	
	if keybinds_as_dict == null:
		print(name, "-> keybinds_as_dict:null: creating new file...")
		createNewFile(save_keybinds_path)
		return
	
	#if keybinds_as_dict != null:
	#check if inputCommand is in keybinds_as_dict and input_dictionary_keys
	for inputCommand in keybinds_as_dict:
		if input_dictionary_keys.has(inputCommand):
			#check if inputCommand keyCode is not null or zero.
			if keybinds_as_dict[inputCommand] != 0 and keybinds_as_dict[inputCommand] != null:
				input_dictionary_keys[inputCommand] = keybinds_as_dict[inputCommand]
				#create new InputEventKey and set it's keycode to inputCommand's keycode
				var new_InputKey = InputEventKey.new()
				new_InputKey.keycode = keybinds_as_dict[inputCommand]
				#check if InputMap has the inputCommand and
				if InputMap.has_action(inputCommand):
					#check thru its events for InputEventKeys
					for previousKey:InputEventKey in InputMap.action_get_events(inputCommand):
						#if previousKey is InputEventKey:
						#delete previous ones and add new ones instead
						InputMap.action_erase_event(inputCommand, previousKey)
						InputMap.action_add_event(inputCommand, new_InputKey)
						print("\n newKey set:action:", inputCommand, "->", OS.get_keycode_string(new_InputKey.keycode))

func createNewFile(filePath:String):
	var file_open = FileAccess.open(filePath, FileAccess.WRITE)
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
