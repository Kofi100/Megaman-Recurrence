extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$debug_settings.visible=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Player.playerCharacter:
		$player_animation_display.set_text("Animation:\n"+Player.playerCharacter.anim.animation)


func _on_fps_15_pressed() -> void:
	Engine.set_max_fps(15)


func _on_fps_30_pressed() -> void:
	Engine.set_max_fps(39)


func _on_fps_60_pressed() -> void:
	Engine.set_max_fps(60)

func _exit_tree() -> void:
	Engine.set_max_fps(60)
	get_tree().set_pause(false)


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
