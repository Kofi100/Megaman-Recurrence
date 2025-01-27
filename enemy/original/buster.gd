extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var shooting:bool=false
var shootNo:int=0
func _ready():
	$allTimers/rapidShootTimer.start()
func _physics_process(delta):
	# Add the gravity.
	if not is_on_ceiling():
		velocity.y -= gravity * delta
	#if shooting==true:
#disables playerdetection if shooting is true and renables when false.
	#$playerDetect/CollisionShape2D.disabled=shooting
	#$playerDetect/CollisionShape2D.disabled=false
	move_and_slide()


func _on_player_detect_area_entered(area):
	if area.is_in_group("player_hitbox"):
		print(name,":detected player")
		#if shooting==false:
			##$playerDetect/CollisionShape2D.disabled=true
			#$allTimers/rapidShootTimer.start()
			#shooting=true


func _on_rapid_shoot_timer_timeout():
	if shootNo<3:
		shootNo+=1
		var proj=preload("res://enemy/original/buster_enemy_projectiles.tscn").instantiate()
		get_parent().add_child(proj)
		proj.global_position=global_position
		$busterShot_SFX.play()
	if shootNo>=3:
		$allTimers/rapidShootTimer.stop()
		$allTimers/cooldownTimer.start()
		#shooting=false
		#$playerDetect/CollisionShape2D.disabled=false
		shootNo=0


func _on_cooldown_timer_timeout():
	$allTimers/rapidShootTimer.start()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	$allTimers/rapidShootTimer.stop()
	$allTimers/cooldownTimer.stop()


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	$allTimers/rapidShootTimer.start()
