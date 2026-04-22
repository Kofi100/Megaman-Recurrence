extends CanvasLayer
var volume_muted:bool=false
var previous_volume
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$debug_settings.visible=false
var saved_data_muted=false
var saved_data_unmuted=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Player.playerCharacter:
		$player_animation_display.set_text("Animation:\n"+Player.playerCharacter.anim.animation)
	#print(volume_muted)
	if volume_muted and saved_data_muted==false:
		saved_data_unmuted=false
		previous_volume= OptionsSet.data["volumeSound"]["BGM"]
		OptionsSet.data["volumeSound"]["BGM"]=0
		OptionsSet.saveSettings()
		saved_data_muted=true
		
		$debug_settings/HFlowContainer/mute_unmute_bgm.text="UNMUTE BGM"
	elif !volume_muted  and saved_data_unmuted==false: 
		
		#print(previous_volume)
		#previous_volume=1
		saved_data_muted=false
		if previous_volume!=null:
			#volume is in decimals now,from 0.0 to 1.0,due to 
			#improved codes in bgm-and sf-groups, for BGM,SF.
			OptionsSet.data["volumeSound"]["BGM"]=previous_volume
		else:
			OptionsSet.data["volumeSound"]["BGM"]=0.5
		OptionsSet.saveSettings()
		saved_data_unmuted=true

		$debug_settings/HFlowContainer/mute_unmute_bgm.text="MUTE BGM"

func _on_fps_15_pressed() -> void:
	Engine.set_max_fps(15)


func _on_fps_30_pressed() -> void:
	Engine.set_max_fps(30)


func _on_fps_60_pressed() -> void:
	Engine.set_max_fps(60)

func _exit_tree() -> void:
	Engine.set_max_fps(60)
	get_tree().set_pause(false)
	#OptionsSet.data["volumeSound"]["BGM"]=previous_volume


func _on_debug_menu_pressed() -> void:
	$debug_settings.set_visible(!$debug_settings.visible)


func _on_restart_level_pressed() -> void:
	get_tree().reload_current_scene()


func _on_go_debug_menu_pressed() -> void:
	var debug_menu=preload("res://levels/main_menu.tscn").instantiate()
	GlobalScript.FastSwitchScene(debug_menu)


func _on_god_mode_pressed() -> void:
	GlobalScript.player_god_mode=!GlobalScript.player_god_mode


func _on_exit_game_pressed() -> void:
	get_tree().quit(0)


func _on_mute_unmute_bgm_pressed() -> void:
	volume_muted=!volume_muted
