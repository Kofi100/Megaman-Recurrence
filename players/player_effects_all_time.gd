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
	var camera = Player.playerCharacter.player_camera

	var viewport_size = get_viewport().get_visible_rect().size
	var zoom = camera.zoom

	var half_width = viewport_size.x * zoom.x * 0.5
	var half_height = viewport_size.y * zoom.y * 0.5

	var left = camera.limit_left #global_position.x - half_width
	var right = camera.limit_right #global_position.x + half_width
	var top = camera.limit_top #global_position.y - half_height
	var bottom = camera.limit_bottom #global_position.y + half_height
	print([left,right,top,bottom])
	
	var min_radius = 50
	var max_radius =200
	var angle = randf_range(0, TAU)
	var distance = randf_range(min_radius, max_radius)

	var offset = Vector2(cos(angle), sin(angle)) * distance
	var spawn_position = Player.playerCharacter.global_position + offset
	#var spawn_position = Player.playerCharacter.global_position + offset
	
	#spawn_position.x = clamp(spawn_position.x, left, right)
	#spawn_position.y = clamp(spawn_position.y, top, bottom)
	#var spawn_positions_new:Vector4
	#print(Player.playerCharacter.global_position.x)
	spawn_position.x=Player.playerCharacter.global_position.x#+300
	const SCREEN_MARGIN = 32
	spawn_position.x = clamp(
		spawn_position.x,
		left + SCREEN_MARGIN,
		right - SCREEN_MARGIN
	)
	#var random_spawn_point_left=randf_range(Player.playerCharacter.global_position.x-256,Player.playerCharacter.global_position.x)
	#spawn_positions_new.w
	spawn_position.y = clamp(
		spawn_position.y,
		top + SCREEN_MARGIN,
		bottom - SCREEN_MARGIN
	)
	print(spawn_position.x)
	var new_scarymare=preload("res://enemy/scarymare.tscn").instantiate()
	new_scarymare.global_position = spawn_position
	get_tree().current_scene.add_child(new_scarymare)
	scarymare_count+=1
	#scarymare.global_position= 
	
#func _on_scarymare_spawn_time_timeout() -> void:
	#if scarymare_count>=5:
		#return
	#var camera_current=Player.playerCharacter.player_camera
	#var camera_current_limits=Vector4(
		#camera_current.get_limit(SIDE_LEFT),
		#camera_current.get_limit(SIDE_RIGHT),
		#camera_current.get_limit(SIDE_TOP),
		#camera_current.get_limit(SIDE_BOTTOM)
		#)
	#var min_radius = 50
	#var max_radius =200
	#var angle = randf_range(0, TAU)
	#var distance = randf_range(min_radius, max_radius)
#
	#var offset = Vector2(cos(angle), sin(angle)) * distance
	#var spawn_position = Player.playerCharacter.global_position + offset
	#
	#var new_scarymare=preload("res://enemy/scarymare.tscn").instantiate()
	#new_scarymare.global_position = spawn_position
	#get_tree().current_scene.add_child(new_scarymare)
	#scarymare_count+=1
	##scarymare.global_position= 
