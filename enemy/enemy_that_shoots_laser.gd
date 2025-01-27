extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var setDirection:int=1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var countdown_Indicator:int=0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if GlobalScreenTransitionTimer.is_stopped()==false:
		$countdownTimer.set_paused(true)
		$emissionTimer.set_paused(true)
	elif GlobalScreenTransitionTimer.is_stopped()==true:
		$countdownTimer.set_paused(false)
		$emissionTimer.set_paused(false)
	if not is_on_wall():
		if setDirection==1:
			velocity.x=3000*delta
		elif setDirection==2:
			velocity.x=-3000*delta
	$laserBody/laser.set_point_position(1,$laserBody/RayCast2D.get_collision_point()-$laserBody.global_position)
	$laserBody/laser2.set_point_position(1,$laserBody/RayCast2D.get_collision_point()-$laserBody.global_position)
	$laser_Indicator.set_point_position(1,$laserBody/RayCast2D.get_collision_point()-$laserBody.global_position)
	if countdown_Indicator==4:
		$emissionTimer.start()
	if $emissionTimer.is_stopped()==false:
		$laserBody/Area2D/CollisionShape2D.disabled=false
		$laserBody.visible=true;$laser_Indicator.visible=false
		$countdownTimer.stop()
		countdown_Indicator=0
	if $emissionTimer.is_stopped()==true:
		$laserBody/Area2D/CollisionShape2D.disabled=true
		$laserBody.visible=false;$laser_Indicator.visible=true
		if $countdownTimer.is_stopped()==true:
			$countdownTimer.start()
	indicateCdown($countdown_Ind)
	indicateCdown($countdown_Ind2)
	indicateCdown($countdown_Ind3)
	indicateCdown($countdown_Ind4)
	move_and_slide()


func _on_countdown_timer_timeout() -> void:
	countdown_Indicator+=1

func indicateCdown(label:Label):
	label.text=str(countdown_Indicator)
