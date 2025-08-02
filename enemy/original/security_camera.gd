extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var RightFacing:bool=true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_wall():
		if RightFacing:
			velocity.x-=gravity*delta
		elif !RightFacing:
			velocity.x += gravity * delta
	#if $allTimers/detectTimer.is_stopped()==true:
		##$AnimatedSprite2D.play("Idle")
		#$detectPlayerLine/CollisionShape2D.disabled=false
	if $allTimers/detectTimer.is_stopped()==false:
		$detectPlayerLine/CollisionShape2D.disabled=true
	move_and_slide()


func _on_detect_player_line_area_entered(area):
	if area.is_in_group("player_hitbox"):
		if $allTimers/detectTimer.time_left<=0:
			$allTimers/detectTimer.start()
			$allTimers/repeatDetectionTimer.stop()
			$AnimatedSprite2D.play("Detect")
			#$detectPlayerLine.set_monitoring(false)
			$detectPlayerLine/CollisionShape2D.set_deferred("disabled",true)


func _on_detect_timer_timeout():
	$AnimatedSprite2D.play("Idle")
	#$detectPlayerLine.set_monitoring(true)
	$detectPlayerLine/CollisionShape2D.disabled=false
	$allTimers/repeatDetectionTimer.start()

func _on_repeat_detection_timer_timeout():
	match $detectPlayerLine/CollisionShape2D.disabled:
		true:$detectPlayerLine/CollisionShape2D.disabled=false
		false:$detectPlayerLine/CollisionShape2D.disabled=true
