#@tool
extends Node2D
signal BossDefeated
var signalReceived: bool = false  #yep,this is a Calamity reference


# Called when the node enters the scene tree for the first time.
func _ready():
	BossDefeated.connect(BossDefeat)
	GlobalScript.set_stage_name("Military\n Base")
	#GlobalScript.boss = null
	GlobalScript.reset_boss_before_starting_stage()
	GlobalScript.player = $megaman
	GlobalScript.boss = $Shadowman_1
	GlobalScript.trigger_boss = false
	GlobalScript.boss.set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalScript.boss.health <= 0 and signalReceived == false:
		GlobalScript.boss.set_physics_process(false)
		BossDefeated.emit()
		signalReceived = true
		$boss_theme_test.stop()
		#$megaman/all_sounds/level_cleared.play()
		#if GlobalScript.trigger_boss == true and hasPlayed == false:
		#$boss_theme_test.play()
		#$BGM_ShadowMan.stop()
		#hasPlayed = true
	#print("ShadowmAN INTRO TIMER:", $Shadowman_1/Timers/introTimer.time_left)


func _on_bgm_shadow_man_finished():
	$BGM_ShadowMan.play()


var aboutToLeave: bool = false


func BossDefeat():
	if $megaman.leave_bool == false:
		$megaman.leave_bool = true
	$megaman/leave_timer.start()


var playerEntered = false


func _on_detect_player_enter_boss_room_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d") and playerEntered == false:
		$Shadowman_1/Timers/introTimer.start()
		$Timer.start()
		playerEntered = true
		print("Player has entered the boss room:ShadowMan")


var hasPlayed = false


func _on_intro_timer_timeout() -> void:
	##if GlobalScript.trigger_boss == true:
	$BGM_ShadowMan.stop()
	$boss_theme_test.play()
	#$Shadowman_1/Timers/introTimer.one_shot = true
	#hasNotPlayed = true
	pass


func _on_timer_timeout() -> void:
	#$BGM_ShadowMan.stop()
	#$boss_theme_test.play()
	pass


func _on_boss_theme_test_finished() -> void:
	$boss_theme_test.play()
