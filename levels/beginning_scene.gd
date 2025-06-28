extends Node2D
var pressedPause:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$press_Start/blink_Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and pressedPause==false:
		$main_Menu_BGM.stop()
		$press_Start/blink_Timer.stop()
		$press_Start.visible=true
		$inputReceived.play()
		$boxArtOrTitle.play("default")
		pressedPause=true


func _on_blink_timer_timeout() -> void:
	$press_Start.set_visible(!$press_Start.visible)


func _on_box_art_or_title_animation_finished() -> void:
	await get_tree().create_timer(.3).timeout
	var mainMenuNew=preload("res://levels/main_Menu_New.tscn").instantiate()
	GlobalScript.FastSwitchScene(mainMenuNew)
	#get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")
