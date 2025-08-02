extends CanvasLayer
signal FillBarUp
var foundBoss:bool=false
@export var BosstextureProgressBar:TextureProgressBar
@export var usingBossTextBar:bool=false
var signalReceived:bool=false
signal BossDefeated
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Boss.bossCharacter!=null and foundBoss==false:
		match usingBossTextBar:
			false:
				$ProgressBar.max_value=Boss.bossCharacter.health#GlobalScript.boss.health
				$ProgressBar.visible=false
				#$ProgressBar.value=0
				FillBarUp.connect(BossReady)
				foundBoss=true
			true:
				if BosstextureProgressBar:
					$ProgressBar.visible=false
					BosstextureProgressBar.max_value=Boss.bossCharacter.health#GlobalScript.boss.health
					BosstextureProgressBar.visible=false
					FillBarUp.connect(BossReady)
					foundBoss=true
	if Boss.bossCharacter:#GlobalScript.boss:
		match usingBossTextBar:
			false:
				$ProgressBar.value=Boss.bossCharacter.health#GlobalScript.boss.health
			true:
				if BosstextureProgressBar:
					BosstextureProgressBar.value=Boss.bossCharacter.health#GlobalScript.boss.health
		if Boss.bossCharacter.health<=0:
			Boss.bossCharacter.set_physics_process(false)
			visible=false
			#Boss.bossCharacter.queue_free() #test feature for intiating boss defeat

			for node in Boss.bossCharacter.get_children():
				if node is Timer:
					#print(i)
					node.stop()
			#print(signalReceived)
			if signalReceived==false:
				if Player.playerCharacter:
					if Boss.bossCharacter.leaveUponDefeatingBoss==true:
						#if $timeDelayPlayerClearSound.is_stopped():
						for node in get_tree().current_scene.get_children():
							if node is BGM:
								node.stop()
							$timeDelayPlayerClearSound.start()
							print("timeDelayPlayerClearSound:active")
							
							signalReceived=true
						#Player.playerCharacter.leave_bool=true
						#Player.playerCharacter.leave_timer.start()
						#signalReceived=true

func BossReady():
	if get_parent():
		#get_parent().set_physics_process(false)
		get_tree().set_pause(true)
		print(name,":Froze Physics of Scene")
		var tween=create_tween()
		tween.connect("finished",TweenFinished)
		if usingBossTextBar==false:
			$ProgressBar.visible=true
			tween.tween_property($ProgressBar,"value",$ProgressBar.max_value,1).from(0)
		elif usingBossTextBar==true and BosstextureProgressBar:
			BosstextureProgressBar.visible=true
			tween.tween_property(BosstextureProgressBar,"value",BosstextureProgressBar.max_value,1).from(0)
	

func TweenFinished():
	if get_parent():
		get_tree().set_pause(false)
		#get_parent().set_physics_process(true)
		pass

#delays seconds before Sound for Leaving plays
func _on_time_delay_player_clear_sound_timeout() -> void:
	Player.playerCharacter.leave_bool=true
	Player.playerCharacter.leave_timer.start()
	Player.playerCharacter.disable_input=true
	
