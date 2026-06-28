extends CanvasLayer
@onready var health_bar = $healthbar
@export_category("timer")
@onready var minutes = $timer/minutes
@onready var seconds = $timer/seconds
@onready var millsecs = $timer/millsecs
@export_category("other values")
var music_node
var selection_index = 0  #var tween=create_tween() #use tween to create a transiton effect for increasing the health of the player
##This boolean pauses all inputs to the HUD for some effects.
var pause_input = false
var color
var justPausedGameManually: bool = false
var onAnotherScreen:bool=false
var screen2
@export var colorPalette:ColorPaletteResource
# Called when the node enters the scene tree for the first time.
func _ready():
	#GlobalSignalBus.player_is_ready.connect()
	GlobalScript.trigger_boss = false
	#$pause_screen_setup/ConfirmationDialog.hide()
	color = $fade_out_rectangle.color
	#print(color)
	#GlobalLogger.info(name,"final color of $fade_out_rectangle :%s" %color)
	var tween_fadeIn = create_tween()
	$fade_out_rectangle.visible = true
	$fadeInRect.visible = true
	tween_fadeIn.tween_property($fadeInRect, "color", Color8(0, 0, 0, 0), 2).from(Color8(0, 0, 0, 255))
	tween_fadeIn.finished.connect(fadeIn_finished)
	#$stage_name.visible=true



var justDied: bool = false


func fadeIn_finished():
	#GlobalLogger.info(name,"beginning fade-out finished")
	$fadeInRect.visible = false
	#$ready_Text.visible=true
	
	#$fade_out_rectangle.color=color


var gotten_bgm_value = false
var original_background_volume_db: int
var start_boss_timer: bool = false
var switchedMenus: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$healthbar/text_health_display.text = str(int(health_bar.value))
	if GlobalScript.max_lives<9:
		$healthbar/text_lives.text = str(int(GlobalScript.lives))
	else:
		$healthbar/text_lives.text = ""
	$score.text = str("SCORE:", GlobalScript.score)
	$stage_name.text = "STAGE:\n" + GlobalScript.stage_name
	$fps_Display.text=str(int(Engine.get_frames_per_second()))
	
	$pause_screen_setup/PauseScreenTimer.text="TIMER:"+str(GlobalScript.minute_level).pad_zeros(2)+":"+str(int(GlobalScript.second_level)).pad_zeros(2)
	$timer/InGame.text="TIMER:"+str(GlobalScript.minute_level).pad_zeros(2)+":"+str(int(GlobalScript.second_level)).pad_zeros(2)
	#print(selection_index)
	#pause on death effect
	if GlobalScript.health <= 0 and justDied == false:
		justDied = true
		$justDiedTimer.start()
	if GlobalScript.boss:
		if GlobalScript.boss.health <= 0 and justDied == false:
			justDied = true
			$justDiedTimer.start()
	if $justDiedTimer.is_stopped() == false:
		#Engine.time_scale=0.1
		if is_instance_valid(Player.playerCharacter):
			if GlobalScript.health<=0:
				Player.playerCharacter.anim.play("stun_air")
		get_tree().paused = true
	if $stage_name/stage_display_timer.time_left <= 0:
		$stage_name.visible = false

#region Prev Code for Reducing BGM InGame

	#for i in get_tree().current_scene.get_children(true):
	#if i.is_class('AudioStreamPlayer') or i.is_class('AudioStreamPlayer2D'):
	#if i.is_in_group('bgm') and i.playing==true:
	#music_node=i
	#if get_tree().paused==true:# and not gotten_bgm_value:
	##original_background_volume_db=i.volume_db
	##i.volume_db=i.volume_db-5
	##gotten_bgm_value=true
	#i.volume_db=OptionsSet.data["volumeSound"]["BGM"]#-5
	#elif get_tree().paused==false:#and gotten_bgm_value==true:
	##i.volume_db=original_background_volume_db
	##gotten_bgm_value=false
	#i.volume_db=OptionsSet.data["volumeSound"]["BGM"]
	#if GlobalScript.health<=0:
	#i.stop()

#endregion

	#print($map.get_size())
	$pause_screen_setup/ProgressBar.value = GlobalScript.health
	health_bar.value = GlobalScript.health
	health_bar.max_value = GlobalScript.max_health
	$pause_screen_setup/ProgressBar.max_value = GlobalScript.max_health
	$pause_screen_setup/e_tank_left.text = str(GlobalScript.energy_tank_no)
	weapon_energy_update()

	if GlobalScript.trigger_boss == true:
		if start_boss_timer == false:
			start_boss_timer = true
			$boss_healthbar/timer.start()
			if music_node != null and (music_node is AudioStreamPlayer2D or music_node is AudioStreamPlayer):
				pass
				music_node.stop()
				music_node.stream = preload("res://assets/music/Mega Man 3 — Boss Battle (Cover).mp3")
				music_node.play()
		#if
		$boss_healthbar.visible = true
		if $boss_healthbar/timer.time_left > 0:
			if GlobalScript.boss != null and GlobalScript.player != null:
				GlobalScript.boss.set_physics_process(false)
				GlobalScript.player.set_physics_process(false)
			if $boss_healthbar/timer.time_left < 1.5 and $boss_healthbar/timer.time_left < 1.55:
				$boss_healthbar/AnimationPlayer.play("boss_level_up")
		if GlobalScript.boss:
			if GlobalScript.boss.health <= 0:
				GlobalScript.boss.health = 0
				if music_node != null:
					music_node.stop()
	else:
		$boss_healthbar.visible = false
	if update_boss_health == true:
		if GlobalScript.boss:
			$boss_healthbar.value = GlobalScript.boss.health
			$boss_healthbar/text_health_display.text = str(GlobalScript.boss.health)
	#print(GlobalScript.boss.health)
	if GlobalScript.health <= 0:
		for i in get_tree().current_scene.get_children():
			if i is BGM:
				i.stop()

		if $fade_out_effect/AnimationPlayer.current_animation != "fade_out":
			#$fade_out_effect.visible=true
			$fade_out_effect/AnimationPlayer.play("fade_out")
	if get_tree().paused:
		$map.visible = false
		GlobalScript.pause_level_timer()
		$timer/seconds_timer.set_timer_process_callback(false)
	else:
		$map.visible = true
		GlobalScript.start_level_timer()
		$timer/seconds_timer.set_timer_process_callback(true)

	if selection_index < 0:
		selection_index = 12
	elif selection_index > 15:
		selection_index = 0
	if !pause_input:  #if input is not paused yet,#and selection_index!=3
		if Input.is_action_just_pressed("pause") and GlobalScript.health > 0 and Player.playerCharacter.player_ready==true and switchedMenus==false :  #and i pressed the pause button,
			if justPausedGameManually == false and get_tree().paused == false and GlobalScript.health > 0:  #if the tree is paused/not,set it to the opposite state
				justPausedGameManually = true
				get_tree().paused = true
				$pause_menu_sound.play()
				var fade_in_tween = create_tween()  #this creates a tween which creates a dim effect for the pause screen
				fade_in_tween.tween_property($fade_out_rectangle, "color", Color(0, 0, 0, 0), .2)
			elif justPausedGameManually == true and get_tree().paused == true and selection_index<12:
				get_tree().paused = false
				justPausedGameManually = false
	if justPausedGameManually == true:
		$pause_screen_setup.visible = true
		$fade_out_rectangle.visible = true
		$timer/InGame.visible=false
	else:
		$pause_screen_setup.visible = false
		$fade_out_rectangle.visible = false
		$fade_out_rectangle.color = color
		$timer/InGame.visible=true
	if justPausedGameManually == true and switchedMenus == false:
		if Input.is_action_just_pressed("move_up"):
			selection_index -= 1
			if MegamanAndItems.weaponNumberEnabled.has(selection_index):
				while selection_index>=0 and (selection_index<13 and not MegamanAndItems.weaponNumberEnabled[selection_index]):
					selection_index-=1
					if selection_index==-1:
						selection_index=12
				
			$switch_menu_option_sound.play(0)
			#if selection_index<13:
				#if MegamanAndItems.weaponNumberEnabled[selection_index]==false:
					#selection_index-=1
					#GlobalScript.weapon_number-=1
		elif Input.is_action_just_pressed("move_down"):
			selection_index += 1
			#if MegamanAndItems.weaponNumberEnabled.has(selection_index)
			if MegamanAndItems.weaponNumberEnabled.has(selection_index):  #and selection_index!=12:
				while selection_index<12 and not MegamanAndItems.weaponNumberEnabled[selection_index]:
					selection_index+=1
			$switch_menu_option_sound.play(0)
			#if selection_index<13:
				#if GlobalScript.weapon_number==selection_index and MegamanAndItems.weaponNumberEnabled[selection_index]==false:
					#selection_index+=1
					#GlobalScript.weapon_number+=1
		#print(GlobalScript.weapon_number,selection_index)
		elif Input.is_action_just_pressed("move_right"):
			# only switch to right from first set of weapons on left (0-5)
			if selection_index>=0 and selection_index<=5:
				selection_index +=6
				
				if MegamanAndItems.weaponNumberEnabled.has(selection_index):
					while selection_index>=0 and (selection_index<13 and not MegamanAndItems.weaponNumberEnabled[selection_index]):
						selection_index-=1
						if selection_index==-1:
							selection_index=12
			if selection_index>=12 and selection_index<=15:
				selection_index+=1
			$switch_menu_option_sound.play(0)
		elif Input.is_action_just_pressed("move_left"):
			# only switch to left from second set of weapons on right (6-11)
			if selection_index>=6 and selection_index<=11:
				selection_index -=6
				
				if MegamanAndItems.weaponNumberEnabled.has(selection_index):
					while selection_index>=0 and (selection_index<13 and not MegamanAndItems.weaponNumberEnabled[selection_index]):
						selection_index-=1
						if selection_index==-1:
							selection_index=12
			if selection_index>=12 and selection_index<=15:
				selection_index-=1
			$switch_menu_option_sound.play(0)
	elif justPausedGameManually==false:
	#checks if e tank and other options were selected before 
	#resetting the selection Index and weapon Number since weapons get affected too
		if selection_index>=12:
			selection_index = 0
			GlobalScript.weapon_number=0
		if GlobalScript.weapon_number>=0 and GlobalScript.weapon_number<=11:
			selection_index=GlobalScript.weapon_number
	if justPausedGameManually == true:
		if selection_index<13:
			GlobalScript.weapon_number=selection_index
		switchToWeaponNumber(selection_index,0,$pause_screen_setup/weapons/mm_buster)
		switchToWeaponNumber(selection_index,1,$pause_screen_setup/weapons/r_Alarm)
		switchToWeaponNumber(selection_index,2,null)
		switchToWeaponNumber(selection_index,3,null)
		switchToWeaponNumber(selection_index,4,null)
		switchToWeaponNumber(selection_index,5,$pause_screen_setup/weapons/o_Stomper)
		switchToWeaponNumber(selection_index,6,$pause_screen_setup/weapons/s_Strike)
		switchToWeaponNumber(selection_index,7,$pause_screen_setup/weapons/s_Pillow)
		switchToWeaponNumber(selection_index,8,null)
		switchToWeaponNumber(selection_index,9,$pause_screen_setup/weapons/rush_coil)
		switchToWeaponNumber(selection_index,10,$pause_screen_setup/weapons/rush_jet)
		switchToWeaponNumber(selection_index,11,$pause_screen_setup/weapons/rush_search)
		
		#MegamanAndItems.weaponNumberEnabled[1]=false
		#if selection_index==5 and MegamanAndItems.weaponNumberEnabled[5]==true:
			#$pause_screen_setup/weapons/o_Stomper.frame=0
			#GlobalScript.weapon_number=5
		#else:
			#$pause_screen_setup/weapons/o_Stomper.frame=1
		
		if selection_index == 12:  #energy tank selected
			$pause_screen_setup/e_tank.play("selected")
			if Input.is_action_just_pressed("pause") and GlobalScript.health < GlobalScript.max_health:  #shoot pressed,health<max_health
				if GlobalScript.energy_tank_no > 0:  #if energy tank no>0,
					GlobalScript.energy_tank_no -= 1  #deduct by 1

					var tween = create_tween()  #use tween to create a transiton effect for increasing the health of the player
					tween.connect("finished", tween_finished)
					if float(GlobalScript.health <= GlobalScript.max_health / 2):
						tween.tween_property($pause_screen_setup/ProgressBar, "value", GlobalScript.max_health, 2)
					elif float(GlobalScript.health > GlobalScript.max_health / 2):
						tween.tween_property($pause_screen_setup/ProgressBar, "value", GlobalScript.max_health, 0.5)
					pause_input = true
					#if tween.
		else:
			$pause_screen_setup/e_tank.play("not_selected")
		if selection_index == 13:
			$pause_screen_setup/w_tank.play("selected")
		else:
			$pause_screen_setup/w_tank.play("not_selected")
		if selection_index==14:
			$pause_screen_setup/buttons/moveNextScreenbtn.play("selected")
			if Input.is_action_just_pressed("pause") and switchedMenus==false:
				if screen2==null:
					screen2=preload("res://levels/menu_options.tscn").instantiate()
					add_child(screen2)
					#$pause_screen_setup.visible=false
					screen2.connect("tree_exiting", exitMenu)
					#var tween=
					#create_tween().tween_property($pause_screen_setup,"modulate",Color8(0,0,0,0),0.2)
					switchedMenus=true
			#if screen2==null and onAnotherScreen==true:
				#print("setting scene to false")
				#print(screen2)
				#onAnotherScreen=false
				#get_tree().paused=true
				#justPausedGameManually=true
				#$pause_screen_setup.visible=true
					#$pause_screen_setup.
		else:
			$pause_screen_setup/buttons/moveNextScreenbtn.play("notSelected")
		if selection_index==15:
			$pause_screen_setup/buttons/quitStageBtn.play("selected")
			if Input.is_action_just_pressed("pause"):
				get_tree().paused=false
				get_tree().change_scene_to_file("res://levels/save_or_continue_screen.tscn")
		else:
			$pause_screen_setup/buttons/quitStageBtn.play("notSelected")
	#print($pause_screen_setup/ProgressBar.value,previous_value)
	
	trackWeaponEnergy($pause_screen_setup/weapons/r_Alarm/ProgressBar,1)
	trackWeaponEnergy($pause_screen_setup/weapons/o_Stomper/ProgressBar,5)
	trackWeaponEnergy($pause_screen_setup/weapons/s_Strike/ProgressBar,6)
	trackWeaponEnergy($pause_screen_setup/weapons/s_Pillow/ProgressBar,7)
	trackWeaponEnergy($pause_screen_setup/weapons/rush_coil/ProgressBar,9)
	trackWeaponEnergy($pause_screen_setup/weapons/rush_jet/ProgressBar,10)



func switchToWeaponNumber(selectionIdx,weaponIdx,sprite:Sprite2D):
	if selectionIdx==weaponIdx and is_instance_valid(sprite):
		if MegamanAndItems.weaponNumberEnabled[weaponIdx]==true:
			sprite.frame=0
			
			var path=String(sprite.get_path())
			var labelPath=NodePath(path+"/Label")#path+"/Label"
			var label=get_node(labelPath)
			#print(labelPath)
			label.set_modulate(colorPalette.LIGHT_YELLOW_FROM_LIFE_BAR)
		else:
			sprite.visible=false
			#$pause_screen_setup/life_icon/Label.font_color
	
	else:
		if is_instance_valid(sprite):
			if MegamanAndItems.weaponNumberEnabled[weaponIdx]==true:
				sprite.frame=1
				var path=String(sprite.get_path())
				var labelPath=NodePath(path+"/Label")#path+"/Label"
				var label=get_node(labelPath)
				#print(labelPath)
				label.set_modulate(Color.WHITE)
			else:
				sprite.visible=false
#func showAvailableWeapons():
	#pass

func trackWeaponEnergy(node:TextureProgressBar,number:int):
	#if GlobalScript.weapon_number==number:
	node.value=MegamanAndItems.weaponEnergy[number]
func tween_finished():
	GlobalScript.health = GlobalScript.max_health
	pause_input = false
	print("tween finished")


#var previous_value=0
func _on_progress_bar_value_changed(_value):  #if the value of the bar changes
	#previous_value=value
#	if value<GlobalScript.previous_health:
	#this was intended to play a sound if Mega gains health
	#is a bit glitchy as of now
	#if GlobalScript.previous_health < value:  # and it's value>prev.health,
		#if not $increase_health.playing:  #if the sound is not playing
			#$increase_health.play(0)  #play it
	pass

#		#if tween.is_running():
#			$increase_health.play(0)


func weapon_energy_update():
	if GlobalScript.weapon_number != 0:
		$weapon_energy.visible = true
		
	else:
		$weapon_energy.visible = false
	if MegamanAndItems.weaponEnergy.has(GlobalScript.weapon_number):
		$weapon_energy.value=MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]
		$weapon_energy/text_weapon_energy.text=str(int(MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]))
		MegamanAndItems.change_palette($weapon_energy)
	#update_energy_pause_menu()


func update_energy_pause_menu():
	$pause_screen_setup/weapons/mm_buster/ProgressBar.ratio = 1
	$pause_screen_setup/weapons/rush_coil/ProgressBar.value = MegamanAndItems.weapon1energy
	$pause_screen_setup/weapons/rush_coil/ProgressBar.max_value = 30
	$pause_screen_setup/weapons/rush_jet/ProgressBar.value = MegamanAndItems.weapon2energy
	$pause_screen_setup/weapons/rush_jet/ProgressBar.max_value = 30


func _on_quit_button_pressed():
	#get_tree().quit(0)
	get_tree().set_pause(false)
	get_tree().change_scene_to_file("res://levels/robot_master_menu.tscn")


func _on_go_to_menu_btn_pressed():
	$pause_screen_setup/ConfirmationDialog.show()
	pass


func _on_confirmation_dialog_confirmed():
	get_tree().paused = false
	justPausedGameManually = false
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")


func _on_confirmation_dialog_canceled():
	#$pause_screen_setup/ConfirmationDialog.hide()
	pass


func _on_seconds_timer_timeout():
	#GlobalScript.second_level+=1
	pass


func _on_restart_level_btn_pressed():
	pass  # Replace with function body.
	get_tree().paused = false
	justPausedGameManually = false
	get_tree().reload_current_scene()
	#MegamanAndItems.reload_palette()


func _on_timer_timeout():
	print(name, "::timer:turning player,boss Mobile again")
	if GlobalScript.boss:
		GlobalScript.boss.set_physics_process(true)
	GlobalScript.player.set_physics_process(true)


var update_boss_health: bool = false


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"boss_level_up":
			update_boss_health = true


func _on_options_btn_pressed():
	var optionsScene = preload("res://levels/menu_options.tscn").instantiate()
	get_parent().add_child(optionsScene)
	optionsScene.connect("tree_exiting", exitMenu)
	switchedMenus = true
	#optionsScene.global_position=global_position


func exitMenu():
	switchedMenus = false


func _on_just_died_timer_timeout():
	#Engine.time_scale=1
	get_tree().paused = false


func _on_play_ready_timer_timeout() -> void:
	#$ready_Text.visible=true
	#$ready_Text.play("default")
	deactivate_ready_text_activate_player()
	

func deactivate_ready_text_activate_player():
	#await get_tree().create_timer(1).timeout
	$ready_Label.queue_free()
	GlobalSignalBus.player_is_ready.emit()

func _on_ready_label_blink_timer_timeout() -> void:
	$ready_Label.visible=!$ready_Label.visible
