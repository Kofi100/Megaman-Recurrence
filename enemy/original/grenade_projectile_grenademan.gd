extends CharacterBody2D

const SPEED = 5000.0
const JUMP_VELOCITY = -400.0
var gotPlayerPos = false
var stopMoving = false
var happenOnce = false
var timeMult = 2.0
var grav = 980


func _ready() -> void:
	$AnimatedSprite2D.play("default")


func _process(delta: float) -> void:
	if stopMoving == false:
		if not is_on_floor():
			velocity.y += grav * delta
	#time+=delta*timeMult
	move_and_slide()


#var time
func _physics_process(delta: float) -> void:
	if is_on_floor() and stopMoving == false:
		stopMoving = true
	if stopMoving == true and happenOnce == false:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.visible = false
		var explosion = preload("res://enemy/boss/mm3_to_10_explosion_radius.tscn").instantiate()
		add_child(explosion)
		explosion.global_position = global_position
		explosion.scale = Vector2(0.5, 0.5)
		explosion.parent = self
		explosion.playerdamagevalue = 3
		#print("DisX:", GlobalScript.playerposx - global_position.x)
		happenOnce = true


func _throwtoPlayer(targetPos: Vector2, height: float):
	var displacementX = targetPos.x - global_position.x
	var displacementY = targetPos.y - global_position.y
	var newHeight = abs(displacementY) + height

	if displacementY > 0:
		newHeight = height

		#airtime*=0.01

		#velocity=Vector2(displacementX/2,-(displacementY/2))

		#var tween=create_tween()
		#tween.tween_property(self,"velocity",Vector2(velocityX,velocityY),.2)
	var velocityY = -sqrt(2 * grav * newHeight)
	var airtimeUp = sqrt(2 * height / grav)
	var airtimeDown = sqrt(2 * abs(displacementY - height) / grav)

	if displacementY > 0:
		airtimeDown = sqrt(2 * abs(displacementY + height) / grav)

		#airtime*=0.01

		#velocity=Vector2(displacementX/2,-(displacementY/2))

		#var tween=create_tween()
		#tween.tween_property(self,"velocity",Vector2(velocityX,velocityY),.2)
	var airtime = airtimeUp + airtimeDown
	#airtime*=0.01

	var velocityX = displacementX / airtime

	#velocity=Vector2(displacementX/2,-(displacementY/2))
	velocity = Vector2(velocityX, velocityY)

	#var tween=create_tween()
	#tween.tween_property(self,"velocity",Vector2(velocityX,velocityY),.2)
	#print("+++++++++++++++++++++++++++++++++++++++++++++")
	#print("Height:", height)
	#print("Airtime:", airtime)
	#print("airtimeUp:", airtimeUp)
	#print("airtimeDown:", airtimeDown)
	#print("displacementY:", displacementY)
	#print("displacementX:", displacementX)
	#print("velocityY:", velocityY)
	#print("velocityX:", velocityX)
	#print("+++++++++++++++++++++++++++++++++++++++++++++")


var throw_direction: Vector2
var initial_speed: float
var time = 0.0
var initial_position: Vector2
var throw_angle_degree: float


func launch(initial_pos: Vector2, direction: Vector2, desired_distance: float, desired_angle_deg: float):
	initial_position = initial_pos
	throw_direction = direction.normalized()
	throw_angle_degree = desired_angle_deg
	initial_speed = pow(desired_distance * get_gravity().y / sin(2 * deg_to_rad(desired_angle_deg)), 0.5)
	global_position = initial_position
	time = 0.0


func _on_timer_timeout() -> void:
	#var a=preload("res://miscellenaous/effects/indicator_or_tracer.tscn").instantiate()
	#get_parent().add_child(a)
	#a.global_position=global_position
	#var explosion=preload("res://enemy/boss/count_bomb_explosionlosion_radius.tscn").instantiate()
	#add_child(explosion)
	#explosion.global_position=global_position
	#explosion.parent=self
	#explosion.playerdamagevalue=5
	pass
	#print("grenade detonate")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		stopMoving = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
