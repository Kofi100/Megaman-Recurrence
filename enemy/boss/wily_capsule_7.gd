extends enemy
signal Wily7Ready

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var activate_boss=false
var intro_to_boss=false
func _ready():
	health=40
func _physics_process(_delta):
	
	playerdamagevalue=5
	BossDefenseShot1=2#3-2=1
	BossDefenseShot2=3#5-3=2
	is_boss=true
	calculate_player_distance()
	if activate_boss==true:
		if intro_to_boss==false:
			#$"State Engine".current_state="Wily7Intro"
			$AnimatedSprite2D.play("intro")
			intro_to_boss=true
			
	if $allTimers/disappear_time.time_left>=1.1 and $allTimers/disappear_time.time_left<3:
		$AnimatedSprite2D.visible=false;$Sprite2D.visible=false
	if $allTimers/disappear_time.time_left<1 and $allTimers/disappear_time.is_stopped()==false:
		if $allTimers/showWilyTimer.time_left<=0 and $AnimatedSprite2D.visible==false:
			$allTimers/showWilyTimer.start()
	#if $allTimers/showWilyTimer.time_left>0:
		#
	if cycleAttackNo==3:
		cycleAttackNo=0
		$allTimers/countdownToShootDown.start()
	if health<=0:
		for timer in $allTimers.get_children():
			if timer is Timer:
				timer.stop()
		$GPUParticles2D.emitting=true
	move_and_slide()
	if $AnimatedSprite2D.visible==true:
		if $allTimers/hitCoolDownTimer.is_stopped()==false:
			$hitbox_to_be_shot/CollisionShape2D.disabled=true
		elif $allTimers/hitCoolDownTimer.is_stopped()==true:
			$hitbox_to_be_shot/CollisionShape2D.disabled=false
	elif $AnimatedSprite2D.visible==false:
		$hitbox_to_be_shot/CollisionShape2D.disabled=true
func _on_animated_sprite_2d_animation_finished():
	match $AnimatedSprite2D.animation:
		"intro":
			Wily7Ready.emit()
			$AnimatedSprite2D.play("attacking")
			$allTimers/disappear_time.start()

var spawn_proj_positions=[Vector2(0,-30),Vector2(22,30),Vector2(-22,30)]
var cycleAttackNo=0
func _on_timer_timeout():
	cycleAttackNo+=1
	for i in spawn_proj_positions:
		var wily_proj=preload("res://enemy/boss/wily_capsule_7_projectiles.tscn").instantiate()
		get_parent().add_child(wily_proj)
		wily_proj.global_position=global_position+i
	$allTimers/disappear_time.start()
	$hitbox/CollisionShape2D.disabled=true;$hitbox_to_be_shot/CollisionShape2D.disabled=true


func _on_disappear_time_timeout():

	$allTimers/showWilyTimer.stop()
	self.set_modulate(Color8(255,255,255,255))

	$hitbox/CollisionShape2D.disabled=false;$hitbox_to_be_shot/CollisionShape2D.disabled=false
	$allTimers/Timer.start()


func _on_countdown_to_shoot_down_timeout():
	var wily_proj_shootdown=preload("res://enemy/boss/wily_capsule_7_projectiles.tscn").instantiate()
	var wily_proj_shootdown2=preload("res://enemy/boss/wily_capsule_7_projectiles.tscn").instantiate()
	get_parent().add_child(wily_proj_shootdown);get_parent().add_child(wily_proj_shootdown2)
	wily_proj_shootdown.state="gotoGround";wily_proj_shootdown.direction="left"
	wily_proj_shootdown2.state="gotoGround";wily_proj_shootdown2.direction="right"
	wily_proj_shootdown.global_position=global_position
	wily_proj_shootdown2.global_position=global_position


func _on_show_wily_timer_timeout():
#this code shows where wily is by repositioning and
#changing wily's opacity 
#to a low value before dispaeearTimer makes wily reappear 
#after its timeout
	#if $Sprite2D.visible==false:
		#$Sprite2D.visible=true;$AnimatedSprite2D.visible=true
	#if $Sprite2D.visible==true:
		#$Sprite2D.visible=false;$AnimatedSprite2D.visible=false
	global_position.x=randi_range(100,240)
	global_position.y=randi_range(100,200)
	$AnimatedSprite2D.visible=true
	$Sprite2D.visible=true
	self.set_modulate(Color8(255,255,255,155))


func _on_hitbox_to_be_shot_area_entered(area):
	if area.is_in_group("player_projectiles"):
		$allTimers/hitCoolDownTimer.start()
