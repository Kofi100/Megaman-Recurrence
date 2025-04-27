extends CanvasLayer
var menuOption:int=0
var SFXValue
var BGMValue
# Called when the node enters the scene tree for the first time.
func _ready():
	#$BGMSlider.value
	#set values
	BGMValue=OptionsSet.data["volumeSound"]["BGM"]
	SFXValue=OptionsSet.data["volumeSound"]["SFX"]

	#$BGMSlider.connect("drag_ended", changeBGMVolume)  #(true)
	#$SFXSlider.connect("drag_ended", changeSFXVolume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#show values
	$values/BGM.text= str(OptionsSet.data["volumeSound"]["BGM"])
	$values/SFX.text = str(OptionsSet.data["volumeSound"]["SFX"])
	BGMValue=clampi(BGMValue,-60,0)
	SFXValue=clampi(SFXValue,-60,0)
	if Input.is_action_just_pressed("move_up"):
		menuOption-=1
	elif Input.is_action_just_pressed("move_down"):
		menuOption+=1
	menuOption=clampi(menuOption,0,2)
	match menuOption:
		0:
			$SelectArrow.set_global_position($volume_Text/BGM.global_position-Vector2(20,0))
			if Input.is_action_pressed("move_left"):
				BGMValue-=1
				OptionsSet.data["volumeSound"]["BGM"]=BGMValue
				OptionsSet.saveSettings()
			elif Input.is_action_pressed("move_right"):
				BGMValue+=1
				OptionsSet.data["volumeSound"]["BGM"]=BGMValue
				OptionsSet.saveSettings()
		1:
			$SelectArrow.set_global_position($volume_Text/SFX.global_position-Vector2(20,0))
			if Input.is_action_pressed("move_left"):
				SFXValue-=1
				OptionsSet.data["volumeSound"]["SFX"]=SFXValue
				OptionsSet.saveSettings()
			elif Input.is_action_pressed("move_right"):
				SFXValue+=1
				OptionsSet.data["volumeSound"]["SFX"]=SFXValue
				OptionsSet.saveSettings()
		2:
			$SelectArrow.set_global_position($input_Rebind.global_position-Vector2(20,0))
		3:$SelectArrow.set_global_position($Exit.global_position-Vector2(20,0))
	if Input.is_action_just_pressed("shoot"):
		match menuOption:
			2:get_tree().change_scene_to_file("res://levels/input_rebind_menu.tscn")
			3:
				self.queue_free()


func changeBGMVolume(value_changed: bool):
	if value_changed:
		OptionsSet.data["volumeSound"]["BGM"] = $BGMSlider.value
		OptionsSet.saveSettings()


func changeSFXVolume(value_changed: bool):
	if value_changed:
		OptionsSet.data["volumeSound"]["SFX"] = $SFXSlider.value
		OptionsSet.saveSettings()


func _on_exit_pressed():
	self.queue_free()


func _on_bgm_slider_drag_ended(value_changed):
	pass  # Replace with function body.
