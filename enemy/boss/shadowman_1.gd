extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var DashSpeed:float=12000
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	is_boss=true
	health=27
	GlobalScript.trigger_boss=false
func _physics_process(delta):
	is_boss=true
	BossDefenseShot1=1
	BossDefenseShot2=2
	playerdamagevalue=5
	move_and_slide()
	calculate_player_distance()
	

	var distance=GlobalScript.playerposx-global_position.x
	if distance<=0:
		#self.scale.x=1
		$AnimatedSprite2D.flip_h=false
	elif distance>0:
		#self.scale.x=-1
		$AnimatedSprite2D.flip_h=true
	#stoppign engine temporally
#region Disabling physics_processes from 
	#if $Timers/stateEngineStop.time_left>0:
		#$"State Engine".set_physics_process(false)
		#$Timers.set_physics_process(false)
		#print($"State Engine".is_physics_processing())
#endregion
		#$"State Engine"
	if health>0:
		if $Timers/coolDownTimer.time_left>0:
			$hitBox/CollisionShape2D.disabled=true
		elif $Timers/coolDownTimer.time_left<=0:
			$hitBox/CollisionShape2D.disabled=false
	if health<=0:
		visible=false
		
		$"State Engine".set_physics_process(false)
		$hitBox/CollisionShape2D.disabled=true
		for i in $Timers.get_children():
			if i is Timer and i.time_left>0:
				i.stop()

func _on_state_engine_stop_timeout():
		#if $Timers/stateEngineStop.time_left>0:
		#$"State Engine".set_physics_process(true)
		#$Timers.set_physics_process(true)
		pass


func _on_intro_timer_timeout():
	pass # Replace with function body.


func _on_hit_box_area_entered(area):
		if area.is_in_group("player_projectiles"):
			$Timers/coolDownTimer.start()
