extends CanvasLayer
var menuOption:int=0
var SFXValue
var BGMValue
var timer:Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	#$BGMSlider.value
	#set values
	BGMValue=OptionsSet.data["volumeSound"]["BGM"]
	SFXValue=OptionsSet.data["volumeSound"]["SFX"]
	#timer=get_tree().create_timer(.5)
	timer=Timer.new()
	add_child(timer)
	timer.one_shot=false
	#timer.autostart=true
	timer.start(.25)
	timer.connect("timeout",changeselectArrowVisible)

	#$BGMSlider.connect("drag_ended", changeBGMVolume)  #(true)
	#$SFXSlider.connect("drag_ended", changeSFXVolume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#show values
	#$values/BGM.text= str(int(OptionsSet.data["volumeSound"]["BGM"]))
	$volumeBGM.value=int(OptionsSet.data["volumeSound"]["BGM"])
	#$values/SFX.text = str(int(OptionsSet.data["volumeSound"]["SFX"]))
	$volumeSFX.value=int(OptionsSet.data["volumeSound"]["SFX"])
	BGMValue=clampi(BGMValue,-59,-1)
	SFXValue=clampi(SFXValue,-59,-1)
	if Input.is_action_just_pressed("move_left"):
		menuOption-=1
	elif Input.is_action_just_pressed("move_right"):
		menuOption+=1
	menuOption=clampi(menuOption,0,3)
	match menuOption:
		0:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D.global_position)
			if Input.is_action_just_pressed("move_down"):
				BGMValue-=3
				OptionsSet.data["volumeSound"]["BGM"]=BGMValue
				OptionsSet.saveSettings()
			elif Input.is_action_just_pressed("move_up"):
				BGMValue+=3
				OptionsSet.data["volumeSound"]["BGM"]=BGMValue
				OptionsSet.saveSettings()
		1:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D2.global_position)
			if Input.is_action_just_pressed("move_down"):
				SFXValue-=1
				OptionsSet.data["volumeSound"]["SFX"]=SFXValue
				OptionsSet.saveSettings()
			elif Input.is_action_just_pressed("move_up"):
				SFXValue+=1
				OptionsSet.data["volumeSound"]["SFX"]=SFXValue
				OptionsSet.saveSettings()
		2:
			$SelectArrow.set_global_position($allMarkers2D/Marker2D3.global_position)
		3:$SelectArrow.set_global_position($allMarkers2D/Marker2D4.global_position)
	if Input.is_action_just_pressed("pause"):
		match menuOption:
			2:
				get_tree().paused=false
				get_tree().change_scene_to_file("res://levels/input_rebind_menu.tscn")
			3:
				self.queue_free()
	#BGMValue=clampi(BGMValue,-60,0)
	#SFXValue=clampi(SFXValue,-60,0)

func changeselectArrowVisible():
	$SelectArrow.visible=!$SelectArrow.visible

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


func _on_bgm_slider_drag_ended(_value_changed):
	pass  # Replace with function body.


func _on_arrow_blink_timer_timeout() -> void:
	#changeselectArrowVisible()
	pass
