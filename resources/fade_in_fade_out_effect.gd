extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func play_animation(anim_name:String):
	if $AnimationPlayer.get_animation(anim_name)==null:
		GlobalLogger.warn(name,".play_animation():anim_name couldn't be found")
		return
	$AnimationPlayer.play(anim_name)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"fade_in":
			GlobalSignalBus.effect_fade_in_complete.emit()
		"fade_out":
			GlobalSignalBus.effect_fade_out_complete.emit()
