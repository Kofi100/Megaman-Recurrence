extends enemy
var playerAround:bool=false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
func _ready() -> void:
	health=12

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
	calculate_player_distance()
	spawn_collectables()
	playerdamagevalue=8
	if distance_x>0:
		animated_sprite_2d.flip_h=true
	else:
		animated_sprite_2d.flip_h=false
	if abs(distance_x)<30 and abs(distance_y)<30:
		if is_on_floor():
			velocity.y=-40000*delta
			animated_sprite_2d.play("jump_Default")
			$playerDetection/CollisionShape2D.set_deferred("disabled",true)
			$repeatShootTimer/stopDurationTimer.stop()
	else:
		if is_on_floor():
			if animated_sprite_2d.animation=="jump_Default":
				animated_sprite_2d.play("defend_Default")
				$playerDetection/CollisionShape2D.set_deferred("disabled",false)
	match animated_sprite_2d.animation:
		"defend_Default":
			match animated_sprite_2d.flip_h:
				false:
					$shieldHitbox/L.set_deferred("disabled",false)
					$shieldHitbox/R.set_deferred("disabled",true)
				true:
					$shieldHitbox/L.set_deferred("disabled",true)
					$shieldHitbox/R.set_deferred("disabled",false)
		"shoot_Default":
			if animated_sprite_2d.frame!=2:
				match animated_sprite_2d.flip_h:
					false:
						$shieldHitbox/L.set_deferred("disabled",false)
						$shieldHitbox/R.set_deferred("disabled",true)
					true:
						$shieldHitbox/L.set_deferred("disabled",true)
						$shieldHitbox/R.set_deferred("disabled",false)
			else:
					$shieldHitbox/L.set_deferred("disabled",true)
					$shieldHitbox/R.set_deferred("disabled",true)
					if $repeatShootTimer.is_stopped():
						$repeatShootTimer.start()
						$repeatShootTimer/durationShootTimer.start()
			
	move_and_slide()


func _on_player_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		#if playerAround==false:
			#playerAround=true
		if $repeatShootTimer/stopDurationTimer.is_stopped():
			$repeatShootTimer/stopDurationTimer.start()



func _on_repeat_shoot_timer_timeout() -> void:
	#code to spawn projectiles
	var proj=preload("res://enemy/returning_machine_joe_bullet.tscn").instantiate()
	get_parent().add_child(proj)
	
	if animated_sprite_2d.flip_h==false:
		proj.direction="left"
		proj.global_position=$shootPositionL.global_position
	elif animated_sprite_2d.flip_h==true:
		proj.direction="right"
		proj.global_position=$shootPositionR.global_position
	


func _on_pause_shoot_timer_timeout() -> void:
	$repeatShootTimer.stop()
	$playerDetection/CollisionShape2D.set_deferred("disabled",false)
	animated_sprite_2d.play("defend_Default")
	#$repeatShootTimer/stopDurationTimer.start()


func _on_stop_duration_timer_timeout() -> void:
	animated_sprite_2d.play("shoot_Default")
	$playerDetection/CollisionShape2D.set_deferred("disabled",true)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
