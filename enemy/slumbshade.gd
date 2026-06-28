extends CharacterBody2D
@export var universal_canvas_modulate:CanvasModulate

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var activate:bool=false
var distance_x
func _ready() -> void:
	$AnimatedSprite2D.play("default")
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Player.playerCharacter:
		#distance_x = Player.playerCharacter.global_position.x-global_position.x
		##print(distance_x)
		#if distance_x>-250:
			#if activate==false:
				#if GlobalScript.slumbshade_darkness_active==false:
					#GlobalScript.slumbshade_darkness_active=true
		if universal_canvas_modulate:
			universal_canvas_modulate.color = Color.WHITE if not GlobalScript.slumbshade_darkness_active else Color(0.151, 0.151, 0.151, 1.0)#Color(Color.BLACK,0.8)
			pass
		$light_radius.visible=GlobalScript.slumbshade_darkness_active
	if not GlobalScreenTransitionTimer.is_stopped():
		
		if GlobalScript.slumbshade_darkness_active and $AnimatedSprite2D.animation=="open_eyes":
			$AnimatedSprite2D.play("default")
		if not GlobalScript.slumbshade_darkness_active and $AnimatedSprite2D.animation=="close_eyes":
			$AnimatedSprite2D.play("open_eyes")
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group('player_projectiles') and universal_canvas_modulate:
		#GlobalLogger.info(name,"code works!")
		if $switch_state_cooldown_timer.is_stopped():
			$switch_state_cooldown_timer.start()
			if GlobalScript.slumbshade_darkness_active:
				$AnimatedSprite2D.play("open_eyes")
			elif !GlobalScript.slumbshade_darkness_active:
				$AnimatedSprite2D.play("close_eyes")
		area.get_parent().queue_free()
		#universal_canvas_modulate.color = Color.WHITE if not GlobalScript.slumbshade_darkness_active else Color.DIM_GRAY
	#if area.is_in_group('player_constants_checker_area2d') and universal_canvas_modulate:
		##GlobalLogger.info(name,"code works!")
		#if not activate:
			#activate=true
			#GlobalScript.slumbshade_darkness_active=false
		


func _on_switch_state_cooldown_timer_timeout() -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"open_eyes":
			GlobalScript.slumbshade_darkness_active = false
		"close_eyes":
			GlobalScript.slumbshade_darkness_active = true
