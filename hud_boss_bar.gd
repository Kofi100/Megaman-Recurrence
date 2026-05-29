extends CanvasLayer
signal FillBarUp
var foundBoss:bool=false
@export var BosstextureProgressBar:TextureProgressBar
@export var boss_health_label:Label
@export var usingBossTextBar:bool=false
var signalReceived:bool=false
#signal BossDefeated
# Called when the node enters the scene tree for the first time.
func _ready():
	FillBarUp.connect(BossReady)
	GlobalSignalBus.boss_has_been_defeated.connect(BossDefeated_Function)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Boss.bossCharacter!=null and foundBoss==false:
		match usingBossTextBar:
			false:
				$ProgressBar.max_value=Boss.bossCharacter.health#GlobalScript.boss.health
				$ProgressBar.visible=false
				#$ProgressBar.value=0
				
				foundBoss=true
			true:
				if BosstextureProgressBar:
					$ProgressBar.visible=false
					BosstextureProgressBar.max_value=Boss.bossCharacter.health#GlobalScript.boss.health
					BosstextureProgressBar.visible=false
					#FillBarUp.connect(BossReady)
					foundBoss=true
	if is_instance_valid(Boss.bossCharacter) :#GlobalScript.boss:
		match usingBossTextBar:
			false:
				$ProgressBar.value=Boss.bossCharacter.health#GlobalScript.boss.health
			true:
				if BosstextureProgressBar:
					BosstextureProgressBar.value=Boss.bossCharacter.health#GlobalScript.boss.health
	if boss_health_label:
		#if usingBossTextBar:
			boss_health_label.text=str(int(Boss.bossCharacter.health))
var previous_BGM
func BossReady():
	if get_parent():
		#get_parent().set_physics_process(false)
		for node in get_tree().current_scene.get_children():
			if node is BGM and node.is_playing():
				previous_BGM=node
				node.stop()
		$BGM_Boss_Battle.play()
		get_tree().set_pause(true)
		print(name,":Froze Physics of Scene")
		var tween=create_tween()
		tween.finished.connect(trigger_Global_Boss_fill_up_signal)
		tween.connect("finished",TweenFinished)
		if usingBossTextBar==false:
			$ProgressBar.visible=true
			tween.tween_property($ProgressBar,"value",$ProgressBar.max_value,1).from(0)
		elif usingBossTextBar==true and BosstextureProgressBar:
			BosstextureProgressBar.visible=true
			tween.tween_property(BosstextureProgressBar,"value",BosstextureProgressBar.max_value,1).from(0)
func trigger_Global_Boss_fill_up_signal():
	GlobalSignalBus.boss_bar_filled_up.emit()
func BossDefeated_Function():
	if is_instance_valid(Boss.bossCharacter):
		if Boss.bossCharacter.health<=0:
			Boss.bossCharacter.set_physics_process(false)
			visible=false
			foundBoss=false
			#Boss.bossCharacter.queue_free() #test feature for intiating boss defeat
			
			for node in Boss.bossCharacter.get_children():
				if node is Timer:
					#print(i)
					node.stop()
			if not Boss.bossCharacter.leaveUponDefeatingBoss:
				if is_instance_valid(previous_BGM):
					previous_BGM.play()
			#print(signalReceived)
			#if signalReceived==false:
			if Player.playerCharacter:
				if Boss.bossCharacter.leaveUponDefeatingBoss==true:
					#if $timeDelayPlayerClearSound.is_stopped():
					for node in get_tree().current_scene.get_children():
						if node is BGM:
							node.stop()
						$timeDelayPlayerClearSound.start()
						print(name,":timeDelayPlayerClearSound:active")
						Player.playerCharacter.leave_bool=true
						Player.playerCharacter.leave_timer.start()
						#signalReceived=true

						#signalReceived=true


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
	


func _on_bgm_boss_battle_finished() -> void:
	$BGM_Boss_Battle.stream=preload("res://assets/music/Boss Battle Loop_Ghost_Entity.ogg")
	$BGM_Boss_Battle.set("parameters/looping",true)#looping=true
	$BGM_Boss_Battle.play()
