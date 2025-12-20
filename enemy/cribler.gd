extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_released_toys:bool=false
func _ready() -> void:
	$AnimatedSprite2D.play("swing")
	health=3
	playerdamagevalue=2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	calculate_player_distance()
	spawn_collectables()
	hurtFlash($AnimatedSprite2D)
	if not is_on_ceiling():
		velocity -= get_gravity() * delta
	if abs(distance_x)<=120:
		pass
		if $AnimatedSprite2D.animation=="swing" and $AnimatedSprite2D.frame==3:
			$AnimatedSprite2D.play("tear")
		if $AnimatedSprite2D.animation=="tear" and $AnimatedSprite2D.frame==2:
			if not is_released_toys:
				create_new_projectile(0,$allPositions/Marker2D)
				create_new_projectile(1,$allPositions/Marker2D2)
				create_new_projectile(2,$allPositions/Marker2D3)
				create_new_projectile(3,$allPositions/Marker2D4)
				is_released_toys=true
		else:
			is_released_toys=false
	

	move_and_slide()

func create_new_projectile(frame_num:int,marker:Marker2D):
	var new_projectile=preload("res://enemy/cribler_toy_projectile.tscn").instantiate()
	new_projectile.frame_number=frame_num
	get_tree().current_scene.add_child(new_projectile)
	new_projectile.global_position=marker.global_position
	new_projectile._throwtoPlayer(Player.playerCharacter.global_position,25)

func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"tear":
			$AnimatedSprite2D.play("swing")
			


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	#is_queued_for_deletion()
