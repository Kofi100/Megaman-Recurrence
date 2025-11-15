extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var setDirection: int = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var countdown_Indicator: int = 0
#@export var laserLineLength
var laserShootOutTimer: float = 0
var laserShotOut = false


func _ready() -> void:
	$countdownTimer.start()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if GlobalScreenTransitionTimer.is_stopped() == false:
		$countdownTimer.set_paused(true)
		$animationPlayTimer.set_paused(true)
	elif GlobalScreenTransitionTimer.is_stopped() == true:
		$countdownTimer.set_paused(false)
		$animationPlayTimer.set_paused(false)
	if not is_on_wall():
		if setDirection == 1:
			velocity.x = 3000 * delta
			$AnimatedSprite2D.flip_h = false
		elif setDirection == 2:
			velocity.x = -3000 * delta
			$AnimatedSprite2D.flip_h = true
	var _distanceXForLaser = $laserBody/RayCast2D.get_collision_point().x - $laserBody/RayCast2D.global_position.x
	#if countdown_Indicator == 4:
	#$emissionTimer.start()
	#if $emissionTimer.is_stopped() == false:
	#$laserBody/Area2D/CollisionShape2D.disabled = false
	#$laserBody.visible = true
	#$laser_Indicator.visible = false
	#$countdownTimer.stop()
	#if laserShotOut == false:
	##var tween = create_tween()
	##tween.tween_property($laserBody/laser, "points[0].x", 200, distanceXForLaser / 16)
	#laserShotOut = true
	#countdown_Indicator = 0
	#if $emissionTimer.is_stopped() == true:
	#$laserBody/Area2D/CollisionShape2D.disabled = true
	#$laserBody.visible = false
	#$laser_Indicator.visible = true
	#laserShotOut = false
	#if $countdownTimer.is_stopped() == true:
	#$countdownTimer.start()

	move_and_slide()


func _on_countdown_timer_timeout() -> void:
	#countdown_Indicator += 1
	pass
	var laserProj = preload("res://enemy/original/original_projs/laser_projectile.tscn").instantiate()
	laserProj.global_position = self.global_position
	get_parent().add_child(laserProj)
	match setDirection:
		1:
			laserProj.direction = "left"
		2:
			laserProj.direction = "right"
	$laserSound.play()
	$AnimatedSprite2D.play("default")
	$animationPlayTimer.start()


func indicateCdown(label: Label):
	label.text = str(countdown_Indicator)


func _on_animation_play_timer_timeout() -> void:
	$AnimatedSprite2D.stop()
