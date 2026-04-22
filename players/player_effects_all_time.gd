extends Node2D
var scarymare

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalScript.slumbshade_darkness_active=false
	#instantiate scenes / nodes / objects to be used
	scarymare=preload("res://enemy/scarymare.tscn").instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var animation_sprite=Player.playerCharacter.anim
	if animation_sprite:
		pass
	light_radius_active()
	slumbershade_effects()
	

func slumbershade_effects():
	if GlobalScript.slumbshade_darkness_active:
		if Player.playerCharacter == null:
			return
		if $scarymare_spawn_time.is_stopped(): $scarymare_spawn_time.start()
	else:
		if not $scarymare_spawn_time.is_stopped(): $scarymare_spawn_time.stop()
		scarymare_count=0

func light_radius_active():
	if GlobalScript.slumbshade_darkness_active:
		$light_radius_megaman.visible=true
	else:
		$light_radius_megaman.visible=false

# this method is meant to reset variables when the player leaves the scene
# or in other words,when you exit or die in a stage
func _exit_tree() -> void:
	GlobalScript.slumbshade_darkness_active=false
	#scarymare_count=0

var scarymare_count=0
func _on_scarymare_spawn_time_timeout() -> void:
	if scarymare_count>=5:
		return
	var min_radius = 50
	var max_radius =200
	var angle = randf_range(0, TAU)
	var distance = randf_range(min_radius, max_radius)

	var offset = Vector2(cos(angle), sin(angle)) * distance
	var spawn_position = Player.playerCharacter.global_position + offset
	
	var new_scarymare=preload("res://enemy/scarymare.tscn").instantiate()
	new_scarymare.global_position = spawn_position
	get_tree().current_scene.add_child(new_scarymare)
	scarymare_count+=1
	#scarymare.global_position= 
