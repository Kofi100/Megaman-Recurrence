extends Node2D
@warning_ignore_start("unused_signal")
signal boss_has_been_defeated
#@warning_ignore("unused_signal")
signal boss_trigger
signal trigger_camera_shake(intensity,duration)
signal player_knockback(direction, force, vertical_force)
signal effect_fade_in_complete
signal effect_fade_out_complete
signal boss_bar_filled_up
@warning_ignore_restore("unused_signal")

#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
