extends Node2D

var isSaving: bool = true
var confirm_choice: bool = false
var confirm_box_show: bool = false
var file_option: int = 0
var weapon_view_values: Dictionary = {}


func _ready() -> void:
	$arrow_blink_timer.start()


func _process(delta: float) -> void:
	# Update view data for current file option
	if file_option <= 4:
		viewData(GlobalScript.SAVEFILE_PATHS[file_option])
	$input_switch_w_left.text = grab_controls("switch_weapon_left") + ":"
	$input_switch_w_right.text = ":" + grab_controls("switch_weapon_right")
	#print(isSaving)
	# Update weapon visibility
	for i in range(min($abilities_grid.get_child_count(), 12)):
		var node = $abilities_grid.get_child(i)
		if weapon_view_values.is_empty():
			node.visible = false
		else:
			node.visible = weapon_view_values.get(i, false)

	# Handle mode switching
	if Input.is_action_just_pressed("switch_weapon_left"):
		isSaving = true

	elif Input.is_action_just_pressed("switch_weapon_right"):
		isSaving = false

	# Handle file selection
	if Input.is_action_just_pressed("move_up"):
		file_option -= 1
	elif Input.is_action_just_pressed("move_down"):
		file_option += 1

	file_option = wrapi(file_option, 0, 6)  # Wrap between 0-5
	if file_option <= 4:
		if $allMarker2Ds.get_child_count() > file_option:
			$SelectArrow.global_position = $allMarker2Ds.get_child(file_option).global_position
	else:
		$SelectArrow.global_position = $allMarker2Ds/Marker2D6.global_position
	# Handle confirmation box logic
	if file_option <= 4:
		if Input.is_action_just_pressed("pause") and not confirm_box_show:
			$confirmBox.show()
			$confirmBox/title.text = "ARE YOU SURE YOU WANT TO SAVE?" if isSaving else "ARE YOU SURE YOU WANT TO LOAD?"
			confirm_box_show = true
			confirm_choice = false
			$input_cooldown_timer.start()

		if confirm_box_show:
			# Handle confirmation selection
			if Input.is_action_just_pressed("move_left"):
				confirm_choice = true
			elif Input.is_action_just_pressed("move_right"):
				confirm_choice = false

			# Update arrow position
			var target_position = $confirmBox/Marker2D.global_position if confirm_choice else $confirmBox/Marker2D2.global_position
			$confirmBox/confirm_select_arrow.global_position = target_position

			# Handle confirmation/cancel
			if Input.is_action_just_pressed("pause") and $input_cooldown_timer.is_stopped():
				if confirm_choice:
					$confirmBox/title.text = "Saving..." if isSaving else "Loading..."
					var result: bool

					if isSaving:
						result = await MegamanAndItems.saveData(GlobalScript.SAVEFILE_PATHS[file_option])
						$confirmBox/title.text = "Saved!" if result else "Save Failed!"
					else:
						result = await MegamanAndItems.loadData(GlobalScript.SAVEFILE_PATHS[file_option])
						$confirmBox/title.text = "Loaded!" if result else "Load Failed!"

					await get_tree().create_timer(1.0).timeout
					if not isSaving and result:
						get_tree().change_scene_to_file("res://levels/robot_master_menu.tscn")
					confirm_box_show = false
					$confirmBox.hide()
				else:
					confirm_box_show = false
					$confirmBox.hide()
		elif not confirm_box_show:
			$confirmBox.hide()
	elif file_option == 5:
		if Input.is_action_just_pressed("pause"):
			print(name, ":exiting..")
			queue_free()


func viewData(file_path: String) -> void:
	#weapon_view_values.clear()

	if not FileAccess.file_exists(file_path):
		weapon_view_values.clear()
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		#file.get_var()  # Skip introSavedState
		var save_data = file.get_var()
		#print(save_data)
		if save_data:
			var weaponEnabledSaveState = save_data.get("weapons_enabled")
			#print([weaponEnabledSaveState,weapon_view_values])
			if weaponEnabledSaveState is Dictionary:
				weapon_view_values = weaponEnabledSaveState
				#print([weaponEnabledSaveState,weapon_view_values])
		file.close()


func grab_controls(action_string):
	var action_list = InputMap.action_get_events(action_string)
	for key in action_list:
		if key is InputEventKey:
			return key.as_text_physical_keycode()


func _on_arrow_blink_timer_timeout() -> void:
	$SelectArrow.visible = !$SelectArrow.visible
	$confirmBox/confirm_select_arrow.visible = !$confirmBox/confirm_select_arrow.visible
