extends Node2D
var scarymare

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	scarymare=preload("res://enemy/scarymare.tscn").instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var animation_sprite=Player.playerCharacter.anim
	if animation_sprite:
		pass
	slumbershade_effects()

func slumbershade_effects():
	if GlobalScript.slumbshade_darkness_active:
		if Player.playerCharacter == null:
			return
		if $scarymare_spawn_time.is_stopped(): $scarymare_spawn_time.start()
	else:
		if not $scarymare_spawn_time.is_stopped(): $scarymare_spawn_time.stop()

func _on_scarymare_spawn_time_timeout() -> void:
	scarymare=preload("res://enemy/scarymare.tscn").instantiate()
	get_tree().current_scene.add_child(scarymare) 
	scarymare.global_position= Player.playerCharacter.global_position + Vector2(randf_range(-256,256),randf_range(-240,240))
