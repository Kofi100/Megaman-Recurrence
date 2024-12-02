extends Node2D
var signalReceived:bool=false
signal BossDefeated

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.set_stage_name("MM7 PTSD")
	GlobalScript.player=$megaman
	GlobalScript.boss=$wily_capsule_7
	$wily_capsule_7.connect("Wily7Ready",HudFill)
	connect("BossDefeated",BossDefeat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalScript.boss:
		#print(GlobalScript.boss.get_children(true))
		if GlobalScript.boss.health<=0 and signalReceived==false:
			GlobalScript.boss.set_physics_process(false)
			$AudioStreamPlayer2D.stop()
			for i in GlobalScript.boss.get_children():
				if i is Timer:
					print(i)
					i.stop()
			BossDefeated.emit()
			signalReceived=true
var aboutToLeave:bool=false
func BossDefeat():
	if $megaman.leave_bool==false:
		$megaman.leave_bool=true
	$megaman/leave_timer.start()



func _on_timer_timeout():
	GlobalScript.boss.activate_boss=true
	$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()

func HudFill():
	$HUD_BossBar.FillBarUp.emit()
