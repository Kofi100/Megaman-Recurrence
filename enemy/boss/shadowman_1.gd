extends Boss

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var DashSpeed: float = 15000
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var firstPhaseAttackNo = 0


func _ready():
	
	is_boss = true
	health = 27
	GlobalScript.trigger_boss = false


func _physics_process(delta):
	#print($HUD_BossBar/ProgressBar.value)
	is_boss = true
	BossDefenseShot1 = 2
	BossDefenseShot2 = 4
	playerdamagevalue = 5
	move_and_slide()
	calculate_player_distance()
	spawn_collectables()
	var distance = GlobalScript.playerposx - global_position.x
	if distance <= 0:
		#self.scale.x=1
		$AnimatedSprite2D.flip_h = false
	elif distance > 0:
		#self.scale.x=-1
		$AnimatedSprite2D.flip_h = true
	#stoppign engine temporally
#region Disabling physics_processes from
	#if $Timers/stateEngineStop.time_left>0:
	#$"State Engine".set_physics_process(false)
	#$Timers.set_physics_process(false)
	#print($"State Engine".is_physics_processing())
#endregion
	#$"State Engine"
	if health > 0:
		if $Timers/coolDownTimer.time_left > 0:
			$hitBox/CollisionShape2D.disabled = true
		elif $Timers/coolDownTimer.time_left <= 0:
			$hitBox/CollisionShape2D.disabled = false
	if health <= 0:
		visible = false
		$BGM.stop()
		$"State Engine".set_physics_process(false)
		$hitBox/CollisionShape2D.disabled = true
		for i in $Timers.get_children():
			if i is Timer and i.time_left > 0:
				i.stop()


func _on_state_engine_stop_timeout():
	#if $Timers/stateEngineStop.time_left>0:
	#$"State Engine".set_physics_process(true)
	#$Timers.set_physics_process(true)
	pass


func _on_intro_timer_timeout():
	pass  # Replace with function body.


func offsetAnimation(animationName: String, offsetLeft: Vector2, offsetRight: Vector2):
	if $AnimatedSprite2D.animation == animationName:
		match $AnimatedSprite2D.flip_h:
			true:
				$AnimatedSprite2D.offset = offsetLeft
			false:
				$AnimatedSprite2D.offset = offsetRight


func _on_hit_box_area_entered(area):
	if area.is_in_group("player_projectiles"):
		$Timers/coolDownTimer.start()
