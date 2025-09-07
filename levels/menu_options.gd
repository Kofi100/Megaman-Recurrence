extends CanvasLayer
var menuOption: int = 0
var SFXValue
var BGMValue
var lives_option: int = 0
var timer: Timer
var buster_type_option: int = 0

var useUpDownKeys: bool = false

#var previous_bgm
# Called when the node enters the scene tree for the first time.
func _ready():
	#$BGMSlider.value
	#set values
	BGMValue = OptionsSet.data["volumeSound"]["BGM"]
	SFXValue = OptionsSet.data["volumeSound"]["SFX"]
	#resolution=OptionsSet.data["resolution"]
	buster_type_option = OptionsSet.data["buster_rapid_shot"]
	$screen_resolution/resolution_display.text = str(int(GlobalScript.resolution))
	match OptionsSet.data["max_lives"]:
		3:
			lives_option = 0
		5:
			lives_option = 1
		9:
			lives_option = 2
			#print("unlimited lives ...")
	#timer=get_tree().create_timer(.5)
	match buster_type_option:
		0:
			$buster_type/buster_type_display.set_text("Charge")
		1:
			$buster_type/buster_type_display.set_text("Rapid Shot")
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	#timer.autostart=true
	timer.start(.25)
	timer.connect("timeout", changeselectArrowVisible)

	#$BGMSlider.connect("drag_ended", changeBGMVolume)  #(true)
	#$SFXSlider.connect("drag_ended", changeSFXVolume)
	#for audio in get_tree().current_scene.get_children():
		#if audio is BGM and audio.get_parent()!=self:
			#if audio.is_playing():
				#audio.stream_paused=true
				#previous_bgm=audio


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#show values
	#$values/BGM.text= str(int(OptionsSet.data["volumeSound"]["BGM"]))
	$volumeBGM.value = int(OptionsSet.data["volumeSound"]["BGM"])
	#$values/SFX.text = str(int(OptionsSet.data["volumeSound"]["SFX"]))
	$volumeSFX.value = int(OptionsSet.data["volumeSound"]["SFX"])

	if lives_option == 0:
		GlobalScript.max_lives = 3
		$lives/lives_display.set_text("3")
	elif lives_option == 1:
		GlobalScript.max_lives = 5
		$lives/lives_display.set_text("5")
	elif lives_option == 2:
		GlobalScript.max_lives = 9
		$lives/lives_display.set_text("Unlimited")

	if not GlobalScript.fullscreen:
		$fullscreen/display.text = "WINDOWED"
	else:
		$fullscreen/display.text = "FULLSCREEN"

	BGMValue = clampi(BGMValue, -59, -1)
	SFXValue = clampi(SFXValue, -59, -1)

	useUpDownKeys = true
	if useUpDownKeys == true:
		if Input.is_action_just_pressed("move_up"):
			menuOption -= 1
		elif Input.is_action_just_pressed("move_down"):
			menuOption += 1
	elif useUpDownKeys == false:
		if Input.is_action_just_pressed("move_left"):
			menuOption -= 1
		elif Input.is_action_just_pressed("move_right"):
			menuOption += 1

	menuOption = wrapi(menuOption, 0, 8)  #clampi
	match menuOption:
		0, 1, 2, 3, 4, 5, 6, 7, 8:
			pass
	match menuOption:
		0:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D.global_position)
			setBGMVolume()
		1:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D2.global_position)
			setSFXVolume()
		2:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D3.global_position)
			setLives()

		3:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D4.global_position)
			setBusterType()
		4:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D5.global_position)
			setWindowSize()
		5:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D6.global_position)
			setFullscreen()

		6:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D7.global_position)
		7:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D8.global_position)
	if Input.is_action_just_pressed("pause"):
		match menuOption:
			6:
				get_tree().paused = false
				get_tree().change_scene_to_file("res://levels/input_rebind_menu.tscn")
			7:
				self.queue_free()
	#BGMValue=clampi(BGMValue,-60,0)
	#SFXValue=clampi(SFXValue,-60,0)

func _exit_tree() -> void:
	#if previous_bgm:
		#previous_bgm.stream_paused=false
	pass
func changeselectArrowVisible():
	$SelectArrow.visible = !$SelectArrow.visible


func changeBGMVolume(value_changed: bool):
	if value_changed:
		OptionsSet.data["volumeSound"]["BGM"] = $BGMSlider.value
		OptionsSet.saveSettings()


func changeSFXVolume(value_changed: bool):
	if value_changed:
		OptionsSet.data["volumeSound"]["SFX"] = $SFXSlider.value
		OptionsSet.saveSettings()


func setBGMVolume():
	if Input.is_action_just_pressed("move_left"):
		BGMValue -= 3
		OptionsSet.data["volumeSound"]["BGM"] = BGMValue
		OptionsSet.saveSettings()
	elif Input.is_action_just_pressed("move_right"):
		BGMValue += 3
		OptionsSet.data["volumeSound"]["BGM"] = BGMValue
		OptionsSet.saveSettings()


func setSFXVolume():
	if Input.is_action_just_pressed("move_left"):
		SFXValue -= 3
		OptionsSet.data["volumeSound"]["SFX"] = SFXValue
		OptionsSet.saveSettings()
	elif Input.is_action_just_pressed("move_right"):
		SFXValue += 3
		OptionsSet.data["volumeSound"]["SFX"] = SFXValue
		OptionsSet.saveSettings()


func setBusterType():
	if Input.is_action_just_pressed("move_left"):
		buster_type_option -= 1
	elif Input.is_action_just_pressed("move_right"):
		buster_type_option += 1
	buster_type_option = wrap(buster_type_option, 0, 2)
	match buster_type_option:
		0:
			$buster_type/buster_type_display.set_text("Charge")
			OptionsSet.data["buster_rapid_shot"] = false
		1:
			$buster_type/buster_type_display.set_text("Rapid Shot")
			OptionsSet.data["buster_rapid_shot"] = true
	GlobalScript.buster_rapid_shot = OptionsSet.data["buster_rapid_shot"]
	OptionsSet.saveSettings()


func setLives():
	if Input.is_action_just_pressed("move_left"):
		lives_option -= 1
		#GlobalScript
		#OptionsSet.data["max_lives"]=lives_option
		#OptionsSet.saveSettings()
	elif Input.is_action_just_pressed("move_right"):
		lives_option += 1

	lives_option = wrap(lives_option, 0, 3)

	OptionsSet.data["max_lives"] = GlobalScript.max_lives
	OptionsSet.saveSettings()


func setWindowSize():
	if Input.is_action_just_pressed("move_left"):
		GlobalScript.resolution -= 1
		OptionsSet.data["resolution"] = GlobalScript.resolution
		OptionsSet.saveSettings()
	elif Input.is_action_just_pressed("move_right"):
		GlobalScript.resolution += 1
		OptionsSet.data["resolution"] = GlobalScript.resolution
		OptionsSet.saveSettings()
	GlobalScript.resolution = wrap(GlobalScript.resolution, 1, 5)
	$screen_resolution/resolution_display.set_text(var_to_str(GlobalScript.resolution))


func setFullscreen():
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		GlobalScript.fullscreen = !GlobalScript.fullscreen
		OptionsSet.data["fullscreen"] = GlobalScript.fullscreen
		OptionsSet.saveSettings()


func _on_exit_pressed():
	self.queue_free()


func _on_bgm_slider_drag_ended(_value_changed):
	pass  # Replace with function body.


func _on_arrow_blink_timer_timeout() -> void:
	#changeselectArrowVisible()
	pass
