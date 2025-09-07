extends Node2D

# File paths
const KEYBOARD_BINDS_PATH = "user://keyboard_binds.cfg"
const GAMEPAD_BINDS_PATH = "user://gamepad_binds.cfg"

# Input actions
enum InputActions { MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, JUMP, DASH, SHOOT, PAUSE, SWITCH_WEAPON_LEFT, SWITCH_WEAPON_RIGHT }

# UI navigation
var current_selection: int = 0
var max_options: int = 20
var is_waiting_for_input: bool = false
var current_action: String = ""
var is_keyboard_binding: bool = true

@onready var ui_elements = {
	# Keyboard bindings
	0: $keyboard_Settings/up,
	1: $keyboard_Settings/down,
	2: $keyboard_Settings/left,
	3: $keyboard_Settings/right,
	4: $keyboard_Settings/jump,
	5: $keyboard_Settings/dash,
	6: $keyboard_Settings/shoot,
	7: $keyboard_Settings/pause,
	8: $keyboard_Settings/switchWeaponL,
	9: $keyboard_Settings/switchWeaponR,
	# Gamepad bindings
	10: $gampad_Settings/up,
	11: $gampad_Settings/down,
	12: $gampad_Settings/left,
	13: $gampad_Settings/right,
	14: $gampad_Settings/jump,
	15: $gampad_Settings/dash,
	16: $gampad_Settings/shoot,
	17: $gampad_Settings/pause,
	18: $gampad_Settings/switchWeaponL,
	19: $gampad_Settings/switchWeaponR,
	# Main menu
	20: $main_menu
}

var action_names = ["move_up", "move_down", "move_left", "move_right", "jump", "dash", "shoot", "pause", "switch_weapon_left", "switch_weapon_right"]


func _ready():
	load_bindings()
	update_ui_display()
	$selectArrow.position = ui_elements[0].position - Vector2(10, 0)


func _process(_delta):
	if is_waiting_for_input:
		return
	$mega_spin.play("spinnnn")
	handle_navigation_input()
	update_selection_arrow()
	handle_confirmation_input()
	update_ui_display()
	#print(InputMap.get_actions())


func handle_navigation_input():
	if Input.is_action_just_pressed("move_up"):
		current_selection -= 1
	elif Input.is_action_just_pressed("move_down"):
		current_selection += 1
	elif Input.is_action_just_pressed("move_left"):
		current_selection -= 10
	elif Input.is_action_just_pressed("move_right"):
		current_selection += 10
	current_selection = clampi(current_selection, 0, 20)


func update_selection_arrow():
	if current_selection in ui_elements:
		$selectArrow.position = ui_elements[current_selection].position - Vector2(23, 0)
		if current_selection > 9 and current_selection <= 19:
			$selectArrow.position = ui_elements[current_selection].position + Vector2(100, 0)
		#print(ui_elements[current_selection])


func handle_confirmation_input():
	if Input.is_action_just_released("shoot"):
		if current_selection in range(0, 20):
			start_rebinding()
		elif current_selection == 20:
			get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")


func start_rebinding():
	current_action = action_names[current_selection % 10]
	is_keyboard_binding = current_selection < 10
	is_waiting_for_input = true
	$waiting_text_label.visible = true
	$waiting_text_BG_Color_Rect.visible = true


func _input(event):
	if !is_waiting_for_input:
		return

	if Input.is_action_just_pressed("die_debug"):
		cancel_rebinding()
		return

	if is_keyboard_binding and (event is InputEventKey):  # or event is InputEventMouseButton):
		if event.is_released():
			rebind_keyboard_action(event)
	elif !is_keyboard_binding and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		if event.is_released():
			rebind_gamepad_action(event)


func rebind_keyboard_action(event: InputEvent):
	# Clear existing keyboard bindings for this action
	clear_action_events(current_action, "InputEventKey")
	#for events in InputMap.action_get_events(current_action):
	#
	#if events is InputEventAction or event is InputEventKey:
	#print(events)
	#InputMap.action_erase_event(current_action,events)
	#clear_action_events(current_action, InputEventMouseButton)

	# Add new binding
	InputMap.action_add_event(current_action, event)
	save_keyboard_binding()
	finish_rebinding()


func rebind_gamepad_action(event: InputEvent):
	# Clear existing gamepad bindings for this action
	clear_action_events(current_action, "InputEventJoypadButton")
	clear_action_events(current_action, "InputEventJoypadMotion")

	# Add new binding
	#if event is InputEventJoypadMotion:
		#event.deadzone = 0.2
	InputMap.action_add_event(current_action, event)
	save_gamepad_binding()
	finish_rebinding()


func clear_action_events(action: String, event_type: String):
	for e in InputMap.action_get_events(action):
		match event_type:
			"InputEventJoypadButton":
				if e is InputEventJoypadButton:
					print(e)
					InputMap.action_erase_event(action, e)
			"InputEventJoypadMotion":
				if e is InputEventJoypadMotion:
					print(e)
					InputMap.action_erase_event(action, e)
			"InputEventKey":
				if e is InputEventKey:
					print(e)
					InputMap.action_erase_event(action, e)
			"MOUSE":
				if e is InputEventMouseButton:
					print(e)
					InputMap.action_erase_event(action, e)
		print(action, ":cleared")


func finish_rebinding():
	is_waiting_for_input = false
	$waiting_text_label.visible = false
	$waiting_text_BG_Color_Rect.visible = false
	update_ui_display()


func cancel_rebinding():
	is_waiting_for_input = false
	$waiting_text_label.visible = false
	$waiting_text_BG_Color_Rect.visible = false


func save_keyboard_binding():
	var config = ConfigFile.new()
	for actionTest in action_names:
		if InputMap.get_actions().has(actionTest):
			#print(actionTest)
			var firstEvent = get_first_keyboard_event(actionTest)
			if firstEvent is InputEventKey:
				config.set_value(actionTest, "type", "key")
				config.set_value(actionTest, "keycode", firstEvent.keycode)
				config.set_value(actionTest, "physical_keycode", firstEvent.physical_keycode)
	#if event is InputEventKey:
	#config.set_value(action, "type", "key")
	#config.set_value(action, "keycode", event.keycode)
	#config.set_value(action, "physical_keycode", event.physical_keycode)
	#elif event is InputEventMouseButton:
	#config.set_value(action, "type", "mouse")
	#config.set_value(action, "button_index", event.button_index)
	config.save(KEYBOARD_BINDS_PATH)


func save_gamepad_binding():
	var config = ConfigFile.new()
	for action in InputMap.get_actions():
		if action_names.has(action):
			var firstEvent = get_first_gamepad_event(action)
			if firstEvent is InputEventJoypadButton:
				config.set_value(action, "type", "gamepad_button")
				config.set_value(action, "button_index", firstEvent.button_index)
				config.set_value(action, "device", firstEvent.device)
			elif firstEvent is InputEventJoypadMotion:
				config.set_value(action, "type", "gamepad_axis")
				config.set_value(action, "axis", firstEvent.axis)
				config.set_value(action, "axis_value", firstEvent.axis_value)
				config.set_value(action, "device", firstEvent.device)

	config.save(GAMEPAD_BINDS_PATH)


func load_bindings():
	load_keyboard_bindings()
	load_gamepad_bindings()


func load_keyboard_bindings():
	var config = ConfigFile.new()
	var err = config.load(KEYBOARD_BINDS_PATH)

	if err != OK:
		return

	for action in action_names:
		if config.has_section_key(action, "type"):
			var type = config.get_value(action, "type")
			var event: InputEvent

			if type == "key":
				event = InputEventKey.new()
				event.keycode = config.get_value(action, "keycode")
				event.physical_keycode = config.get_value(action, "physical_keycode")
			elif type == "mouse":
				event = InputEventMouseButton.new()
				event.button_index = config.get_value(action, "button_index")

			if event:
				clear_action_events(action, "InputEventKey")
				clear_action_events(action, "InputEventMouseButton")
				InputMap.action_add_event(action, event)


func load_gamepad_bindings():
	var config = ConfigFile.new()
	var err = config.load(GAMEPAD_BINDS_PATH)

	if err != OK:
		return

	for action in action_names:
		if config.has_section_key(action, "type"):
			var type = config.get_value(action, "type")
			var event: InputEvent

			if type == "gamepad_button":
				event = InputEventJoypadButton.new()
				event.button_index = config.get_value(action, "button_index")
				#event.device = config.get_value(action, "device", 0)
			elif type == "gamepad_axis":
				event = InputEventJoypadMotion.new()
				event.axis = config.get_value(action, "axis")
				event.axis_value = config.get_value(action, "axis_value")
				#event.device = config.get_value(action, "device", 0)
				#event.deadzone = 0.2

			if event:
				clear_action_events(action, "InputEventJoypadButton")
				clear_action_events(action, "InputEventJoypadMotion")
				InputMap.action_add_event(action, event)


func update_ui_display():
	for i in range(10):
		update_keyboard_button_display(i)
		update_gamepad_button_display(i + 10)


func update_keyboard_button_display(index: int):
	var action = action_names[index]
	var button = ui_elements[index]
	#var event = get_first_keyboard_event(action)

	#for actionA in action_names:
	#if InputMap.has_action(actionA):
	#
	for event in InputMap.action_get_events(action):
		if event is InputEventAction or event is InputEventKey:
			var string = event_to_string(event)
			#if action=="move_up" :
			#print(event)
			button.text = str(action) + ":" + event_to_string(event)
	#if event is InputEventAction or event_to_string(event)==null:
	#button.text = str(action)+":"+"NULL"
	#return
	if action == "switch_weapon_left":
		action = "switch W L"
	if action == "switch_weapon_right":
		action = "switch W R"
	#button.text = str(action)+":"+event_to_string(event)


func update_gamepad_button_display(index: int):
	var action = action_names[index - 10]
	var button = ui_elements[index]
	var event = get_first_gamepad_event(action)
	if action == "switch_weapon_left":
		action = "switch W L"
	if action == "switch_weapon_right":
		action = "switch W R"
	button.text = str(action) + ":" + event_to_string(event)


func get_first_keyboard_event(action: String) -> InputEvent:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey or event is InputEventAction:
			return event
	return null


func get_first_gamepad_event(action: String) -> InputEvent:
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			return event
	return null


func event_to_string(event: InputEvent) -> String:
	if event == null:
		return "Unbound"

	if event is InputEventKey:
		if event.keycode:
			return OS.get_keycode_string(event.keycode)
		elif event.physical_keycode:
			return OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		return "Mouse " + str(event.button_index)
	elif event is InputEventJoypadButton:
		return "Button " + str(event.button_index)
	elif event is InputEventJoypadMotion:
		var axis_name = "Axis " + str(event.axis)
		axis_name += "+" if event.axis_value > 0 else "-"
		return axis_name
	return "Unknown"


func _on_up_btn_pressed():
	#selected_option = 0
	pass


func _on_down_btn_pressed():
	pass  # Replace with function body.
	#selected_option = 1


func _on_left_btn_pressed():
	pass  # Replace with function body.
	#selected_option = 2


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")  #("res://levels/main_menu.tscn")


func _on_right_btn_pressed():
	#selected_option = 3
	pass


func _on_jump_btn_pressed():
	#selected_option = 4
	pass


func _on_slide_btn_pressed():
	#selected_option = 5
	pass


func _on_shoot_btn_pressed():
	#selected_option = 6
	pass


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()


var inputmap: InputMap


func _on_button_pressed() -> void:
	var scene = PackedScene.new()
	#scene.pack(inputmap)
	##inputmap=InputMap.new()
	#ResourceSaver.save(inputmap,"res://")


func _on_delay_input_timer_timeout() -> void:
	#inputAccept=true
	pass
