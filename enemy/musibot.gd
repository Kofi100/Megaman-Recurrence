extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var previous_frame:int=0
var shoot_one_note_per_frame:bool=false
func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	health=3
	playerdamagevalue=3
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	calculate_player_distance()
	spawn_collectables()
	hurtFlash($AnimatedSprite2D)
	if distance_x<0:
		$AnimatedSprite2D.flip_h=false
	elif distance_x>=0:
		$AnimatedSprite2D.flip_h=true
	if abs(distance_x)<100 and abs(distance_y)<50:
		if $AnimatedSprite2D.animation=="idle" and $attack_cooldown_timer.is_stopped():
			$AnimatedSprite2D.play("opening")
	
	match $AnimatedSprite2D.animation:
		"playing":
			#if :
			if $AnimatedSprite2D.frame%2==0 and (previous_frame!=$AnimatedSprite2D.frame):
				shoot_one_note_per_frame=false
			if shoot_one_note_per_frame==false:
				#print("shoot note")
				var note=preload("res://enemy/musibot_projectile.tscn").instantiate()
				get_tree().current_scene.add_child(note)
				
				if $AnimatedSprite2D.flip_h==true:
					note.global_position=$shoot_Marker2D_R.global_position
					note.direction=Vector2.RIGHT
				elif $AnimatedSprite2D.flip_h==false:
					note.global_position=$shoot_Marker2D_L.global_position
					note.direction=Vector2.LEFT
				shoot_one_note_per_frame=true
			previous_frame=$AnimatedSprite2D.frame
	if $AnimatedSprite2D.animation!="playing":
		$block_area/CollisionShape2D.set_deferred("disabled",false)
	else:
		$block_area/CollisionShape2D.set_deferred("disabled",true)
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		#if $AnimatedSprite2D.animation=="idle":
			#$AnimatedSprite2D.play("opening")
		pass


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"opening":
			$AnimatedSprite2D.play("playing")
		"playing":
			$AnimatedSprite2D.play("closing")
		"closing":
			$AnimatedSprite2D.play("idle")
			if $attack_cooldown_timer.is_stopped():$attack_cooldown_timer.start()

var play_time_count:int=0
func _on_animated_sprite_2d_animation_looped() -> void:
	match $AnimatedSprite2D.animation:
		"playing":
			if play_time_count<2:
				play_time_count+=1
				


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
