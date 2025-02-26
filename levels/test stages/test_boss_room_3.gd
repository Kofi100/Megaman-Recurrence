extends Node2D
signal BossDefeated
var signalReceived: bool = false  #yep,this is a Calamity reference


# Called when the node enters the scene tree for the first time.
func _ready():
	BossDefeated.connect(BossDefeat)
	GlobalScript.set_stage_name("TEST BOSS \nROOM 3")
	GlobalScript.reset_boss_before_starting_stage()
	GlobalScript.player = $megaman
	GlobalScript.boss = $Shadowman_1
	GlobalScript.trigger_boss = false
	GlobalScript.boss.set_physics_process(false)
	$Shadowman_1/Timers/introTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print($megaman/leave_timer.time_left)
	if GlobalScript.boss.health <= 0 and signalReceived == false:
		GlobalScript.boss.set_physics_process(false)
		BossDefeated.emit()
		signalReceived = true
		$boss_theme_test.stop()


var aboutToLeave: bool = false


func BossDefeat():
	if $megaman.leave_bool == false:
		$megaman.leave_bool = true
	$megaman/leave_timer.start()


#region temporal check for leaving screens
#if $megaman/leave_timer.time_left==0 and aboutToLeave==false:
#
#aboutToLeave=true


func _on_intro_timer_timeout():
	$boss_theme_test.play()


func _on_boss_theme_test_finished():
	$boss_theme_test.play()
