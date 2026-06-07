extends Node2D
var saved_player_position = false
@onready var detect_player_shape_cast_2d = $detect_player_ShapeCast2D
@onready var animation_player = $AnimationPlayer
var rings:Array[Sprite2D]
@onready var rings_collection = $Rings_collection.get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#calculations done in the second arg of set_point_positon=grab local pos #get_collision_point(1)
	if $detect_player_ShapeCast2D.is_colliding():
		$line_rep.set_point_position(1, detect_player_shape_cast_2d.get_collision_point() - global_position)
	else:
		$line_rep.set_point_position(1, (global_position - Vector2(0, 240)) - global_position)
	if detect_player_shape_cast_2d.is_colliding():
		var body = detect_player_shape_cast_2d.get_collider()  #get_collider(1)
		if body != null and body.is_in_group("player"): #and saved_player_position == false:
			#save code old
			#GlobalScript.playerposx = global_position.x
			#GlobalScript.playerposy = global_position.y - 16
			#GlobalScript.save_savepoint_data()
			#saved_player_position = true
			#body = null
			if Input.is_action_pressed("move_up"):
				if $press_up_timer.is_stopped():
					$press_up_timer.start()
			elif Input.is_action_just_released("move_up"):
				$press_up_timer.stop()
			#queue_free()
	else:
		$press_up_timer.stop()
	
	for ring in rings_collection:
		if global_position.distance_to(ring.global_position)>224:
			ring.position=Vector2.ZERO
	
	match saved_player_position:
		false:  #$line_rep.default_color=Color.RED#(ffffff)
			#animation_player.play("red")
			#$line_rep.default_color=Color.RED
			for single_ring in rings_collection:#rings:
				if is_instance_valid(single_ring):
					single_ring.set_modulate(Color.RED)
		true:
			pass
			#$line_rep.default_color=Color.GREEN
			#animation_player.play("green")
			for single_ring in rings_collection:#rings:
				if is_instance_valid(single_ring):
					single_ring.set_modulate(Color.GREEN)


func _on_spawn_ring_timer_timeout() -> void:
	var ring:Sprite2D=preload("res://miscellenaous/savepoint_energy_ring.tscn").instantiate()
	add_child(ring)
	rings.append(ring)
	#ring.set_modulate(Color.RED)
	


func _on_press_up_timer_timeout() -> void:
	GlobalScript.playerposx = global_position.x
	GlobalScript.playerposy = global_position.y - 16
	GlobalScript.save_savepoint_data()
	saved_player_position = true
	var saved_label:Node2D=preload("res://miscellenaous/saved_label_for_savepoint.tscn").instantiate()
	var player=Player.playerCharacter
	player.add_child(saved_label)
	saved_label.global_position.y=player.global_position.y-20
