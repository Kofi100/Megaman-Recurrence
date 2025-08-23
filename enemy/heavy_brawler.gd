extends enemy
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jump_times=0
var has_jumped:bool=false
var move_to_one_direction:bool=false
var attack_phases=0
func _ready() -> void:
	state="idle"
	$idle_timer.start()
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	calculate_player_distance()
	#print([jump_times,state])
	#if not is_on_floor() :
		#animated_sprite_2d.play("jump")
	if distance_x<=0:
		animated_sprite_2d.flip_h=true
	else:
		animated_sprite_2d.flip_h=false
	if attack_phases>=3:
		pass
		attack_phases=0
	match state:
		"jump":
			if is_on_floor():
				if jump_times < 3:
					#velocity.x=0
					if $jump_cooldown_timer.is_stopped():
						jump_times += 1
						$jump_cooldown_timer.start()
					#if not is_on_floor():
							#if distance_x < 0:
								#velocity.x = -80
							#else:
								#velocity.x = 80
					
				else:
					# Reset after finishing 2 jumps
					jump_times = 0
					$idle_timer.wait_time=.5
					state = "idle"
					velocity.x = 0
					animated_sprite_2d.play("idle")
					
			else:
				#if animated_sprite_2d.animation != "jump":
					#animated_sprite_2d.play("jump")
				if has_jumped==false:
					has_jumped=true
					if distance_x < 0:
							velocity.x = -80
					else:
							velocity.x = 80
			if is_on_floor():
				velocity.x=0
				#animated_sprite_2d.play("idle")
				has_jumped=false
				if animated_sprite_2d.animation=="jump":
					if animated_sprite_2d.frame==2:
						velocity.y = JUMP_VELOCITY
				#if velocity.y>0:
					#animated_sprite_2d.play("idle")
		"punch":
			velocity.x=0
		"attack":
			velocity.x=0

		"idle":
			if animated_sprite_2d.animation != "idle":
				animated_sprite_2d.play("idle")
			velocity.x = 0
			#$jump_cooldown_timer.stop()
			if $idle_timer.is_stopped():
				$idle_timer.start()
				attack_phases+=1
		



	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	match animated_sprite_2d.animation:
		"punch1":#"punch_start"
			animated_sprite_2d.play("punch2")#punch_loop
		"punch2":#punch_loop
			#animated_sprite_2d.play("punch_end")#punch_end
			animated_sprite_2d.play("idle")
			$idle_timer.wait_time=1.5
			state="idle"
		"attack":#punch_end
			animated_sprite_2d.play("idle")#idle
			$idle_timer.wait_time=1.5
			state="idle"
			

func _on_idle_timer_timeout() -> void:
	if attack_phases==0:
		state="jump"
	elif attack_phases==1:
		state="attack"
		animated_sprite_2d.play("attack")
	elif attack_phases==2:
		state="punch"
		animated_sprite_2d.play("punch1")


func _on_jump_cooldown_timer_timeout() -> void:
	if state != "jump":
		return  # don't apply jump if we already went idle
	animated_sprite_2d.play("jump")
	
	
	
	# horizontal push once per jump
	
	#if distance_x < 0:
		#velocity.x = -80
	#else:
		#velocity.x = 80


func _on_knockback_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		print(name,": player in range")
		var directional_force=1 if animated_sprite_2d.flip_h==false else -1
		GlobalScript.emit_signal("player_knockback",directional_force,50,-70)
