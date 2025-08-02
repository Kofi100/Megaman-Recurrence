extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var playerEnterForFirstTime: bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var health: int = 20
var startTimer: bool = false
var patternNo = 1
var setdeadly1 = -1
var setdeadly2 = -1
var setdeadly3 = -1
@onready var main_body: CharacterBody2D = $mainBody


func _physics_process(delta: float) -> void:
	upwardGravity($ceilingLaser, delta)
	upwardGravity($ceilingLaser2, delta)
	upwardGravity($ceilingLaser3, delta)
	upwardGravity($ceilingLaser4, delta)
	sideRGravity($mainBody, delta)
	#sideRGravity($deadlyBody1,delta)
	if main_body:
		health = main_body.health
	else:
		health=0
	if playerEnterForFirstTime == true and health > 0:
		if startTimer == false:
			$attack1Timer.start()
			startTimer = true
			print("mBoss1:attack1started")
			#$mainBody.velocity.y=-3000*delta
			#$bodyRestricter/CollisionShape2D.disabled=false

	#code for making mainBody of miniBoss move on wall
	match setdeadly1:
		-1:
			$deadlyBody1.velocity.y = 0
		0:
			$deadlyBody1.velocity.y = 10000 * delta
			if $deadlyBody1.global_position.y > $deadly1_BeginningDown.global_position.y:
				setdeadly1 = 1
		1:
			$deadlyBody1.velocity.y = -7000 * delta
			if $deadlyBody1.global_position.y < $deadly1_BeginningUp.global_position.y:
				setdeadly1 = -1
	if $mainBodyanimationTimer.is_stopped() == false:
		$mainBody/AnimatedSprite2D.play("active")
	elif $mainBodyanimationTimer.is_stopped() == true:
		$mainBody/AnimatedSprite2D.play("notActive")

	match setdeadly2:
		-1:
			$deadlyBody2.velocity.y = 0
		0:
			$deadlyBody2.velocity.y = 10000 * delta
			if $deadlyBody2.global_position.y > $deadly1_BeginningDown.global_position.y:
				setdeadly2 = 1
		1:
			$deadlyBody2.velocity.y = -7000 * delta
			if $deadlyBody2.global_position.y < $deadly1_BeginningUp.global_position.y:
				setdeadly2 = -1
	match setdeadly3:
		-1:
			$deadlyBody3.velocity.y = 0
		0:
			$deadlyBody3.velocity.y = 10000 * delta
			if $deadlyBody3.global_position.y > $deadly1_BeginningDown.global_position.y:
				setdeadly3 = 1
		1:
			$deadlyBody3.velocity.y = -7000 * delta
			if $deadlyBody2.global_position.y < $deadly1_BeginningUp.global_position.y:
				setdeadly3 = -1

	#$deadyBody1.playerdamagevalue=7
	#$deadyBody2.playerdamagevalue=7
	#$deadyBody3.playerdamagevalue=7
	$deadlyBody1.move_and_slide()
	$deadlyBody2.move_and_slide()
	$deadlyBody3.move_and_slide()
	if health <= 0:
		$bodyRestricter/CollisionShape2D.disabled = true
		$bodyRestricter.visible = false
		$attack1Timer.stop()
		$attack2Timer.stop()
		$mainBody/hitBox/CollisionShape2D.disabled = true


func startAttacking():
	pass


func upwardGravity(body: CharacterBody2D, delta: float):
	pass
	if not body.is_on_ceiling():
		body.velocity.y -= gravity * delta


func sideRGravity(body: CharacterBody2D, delta: float):
	pass
	if not body.is_on_wall():
		body.velocity.x += gravity * delta


func setMovementUp(compressor: CharacterBody2D, value_compressor: float, up: Marker2D, down: Marker2D, delta: float):
	match value_compressor:
		-1:
			compressor.velocity.y = 0
		0:
			compressor.velocity.y = 5000 * delta
			if compressor.global_position.y > down.global_position.y:
				value_compressor = 1
		1:
			compressor.velocity.y = -7000 * delta
			if compressor.global_position.y < up.global_position.y:
				value_compressor = -1


func _on_detect_player_entry_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		var player = area.get_parent()
		if playerEnterForFirstTime == false:
			playerEnterForFirstTime = true
			print("mBoss1:player Has Entered")


var deadlyBody1 = false


func _on_attack_1_timer_timeout() -> void:
	#var p1=preload("res://enemy/boss/mini_boss_1_projectile_1.tscn").instantiate()
	print("mBoss1:attack1:timeOut")
	#for i in 4:
	#var p1=preload("res://enemy/boss/mini_boss_1_projectile_1.tscn").instantiate()
	#get_parent().add_child(p1)
	#match i:
	#0:p1.global_position=$ceilingLaser.global_position+Vector2(0,16)
	#1:p1.global_position=$ceilingLaser2.global_position+Vector2(0,16)
	#2:p1.global_position=$ceilingLaser3.global_position+Vector2(0,16)
	#3:p1.global_position=$ceilingLaser4.global_position+Vector2(0,16)

	#var proj1_v2=preload("res://enemy/boss/mini_boss_1_projectile_1_v_2.tscn").instantiate()
	#get_parent().add_child(proj1_v2)
	#proj1_v2.global_position=$deadlyBody1.global_position
	if patternNo == 5:
		patternNo = 1
	match patternNo:
		1:
			setdeadly1 = 0
			setdeadly3 = 0
		2:
			setdeadly3 = 0
			setdeadly2 = 0
		3:
			setdeadly2 = 0
			setdeadly1 = 0
		4:
			setdeadly3 = 0
			setdeadly1 = 0
	patternNo += 1

	$attack2Timer.start()


func _on_attack_2_timer_timeout() -> void:
	print("mBoss1:attack2:timeOut")
	for i in 4:
		var p1 = preload("res://enemy/boss/mini_boss1_proj_2.tscn").instantiate()
		get_parent().add_child(p1)
		match i:
			0:
				p1.global_position = $mainBody/Marker2D.global_position + Vector2(0, 0)
			1:
				p1.global_position = $mainBody/Marker2D2.global_position + Vector2(0, 0)
			2:
				p1.global_position = $mainBody/Marker2D3.global_position + Vector2(0, 0)
			3:
				p1.global_position = $mainBody/Marker2D4.global_position + Vector2(0, 0)
	$attack1Timer.start()
	$mainBodyanimationTimer.start()


func _on_hit_box_area_entered(area: Area2D) -> void:
	pass  # Replace with function body.
