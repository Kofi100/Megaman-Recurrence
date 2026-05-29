extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

var cutscene_triggered:bool=false
func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	if area.is_in_group("player_constants_checker_area2d"):
		#if not cutscene_triggered:
		#var body=area.get_parent()
			#if Player.playerCharacter.velocity.x>0:
			#Player.playerCharacter.disable_input=true
		$Area2D.set_deferred("monitoring",false)
		Player.playerCharacter.disable_input=true
		var normalSpeed=Player.playerCharacter.normalspeed
		Player.playerCharacter.cutscene_velocity=Vector2(normalSpeed,0)
		await get_tree().create_timer(2).timeout
		#Player.playerCharacter.stop=true
		#if area.col
		Player.playerCharacter.cutscene_velocity=Vector2.ZERO
		
		#cutscene_triggered=true
		await get_tree().create_timer(1).timeout
		spawn_rush()
		await get_tree().create_timer(3).timeout
		$cutscene.play("fade_in")

func _on_cutscene_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"fade_in":
			$cutscene.play("pan_up")
		"pan_up":
			$cutscene.play("fade_out")
		"fade_out":
			$cutscene.play("RESET")
			Player.playerCharacter.disable_input=true
			
			var normalSpeed=Player.playerCharacter.normalspeed
			Player.playerCharacter.cutscene_velocity=Vector2.ZERO
			await get_tree().create_timer(1).timeout
			Player.playerCharacter.cutscene_velocity=Vector2(normalSpeed,-300)
			
			await get_tree().create_timer(.5).timeout
			
			#Player.playerCharacter.stop=false
var rush_coil_instance
func spawn_rush():
	var rush=preload("res://players/weapons/rush_coil.tscn")
	rush_coil_instance = rush.instantiate()
	get_parent().add_child(rush_coil_instance)
	#if anim.flip_h == true:
	var player=Player.playerCharacter
	rush_coil_instance.global_position = Vector2(player.global_position.x + 20, player.global_position.y - 50)
	rush_coil_instance.cutscene_stop_move_back_timer=true
	await get_tree().create_timer(1).timeout
	rush_coil_instance.animated_sprite_2d.flip_h=true
	#elif anim.flip_h == false:
		#rush_coil_instance.global_position = Vector2(global_position.x - 20, global_position.y - 50)  #100
	#if rush_coil_instance:
		#print("Rush has spawned")
		#rush_coil_instance.connect("tree_exited", rCoilLeft)


func _on_detect_when_mega_gone_up_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	if area.is_in_group("player_constants_checker_area2d"):
		pass
		#$cutscene.play("fade_out_alt")
		
		Player.playerCharacter.disable_input=true
		Player.playerCharacter.cutscene_velocity=Vector2.ZERO
		Player.playerCharacter.stop=true
		Player.playerCharacter.visible=false
		await get_tree().create_timer(1).timeout
		$fade_in_fade_out_effect.play_animation("fade_in")
		await get_tree().create_timer(1).timeout
		Player.playerCharacter.global_position=$replace_megaman_position.global_position
		#$cutscene.play("fade_in_alt")
		Player.playerCharacter.visible=true
		await get_tree().create_timer(2).timeout
		$fade_in_fade_out_effect.play_animation("fade_out")
		await GlobalSignalBus.effect_fade_out_complete
		
		Player.playerCharacter.anim.play("idle")
		Player.playerCharacter.velocity.x=0
		#await $cutscene.animation_finished
		#wait for .5s,move right for .5s
		await get_tree().create_timer(.5).timeout
		var normalSpeed=Player.playerCharacter.normalspeed
		Player.playerCharacter.cutscene_velocity=Vector2(normalSpeed,0)
		await get_tree().create_timer(.5).timeout
		#stop moving,wait for 1s
		Player.playerCharacter.cutscene_velocity=Vector2.ZERO
		await get_tree().create_timer(1).timeout
		#move left for .5s
		Player.playerCharacter.cutscene_velocity=Vector2(-normalSpeed,0)
		await get_tree().create_timer(.5).timeout
		#stop moving,wait for 1s
		Player.playerCharacter.cutscene_velocity=Vector2.ZERO
		await get_tree().create_timer(1).timeout
		#trigger boss
		GlobalSignalBus.boss_trigger.emit()
		#turn right (for a shortwhile) and stop
		await get_tree().create_timer(.7).timeout
		Player.playerCharacter.cutscene_velocity=Vector2(1,0)
		await get_tree().create_timer(.1).timeout
		Player.playerCharacter.cutscene_velocity=Vector2.ZERO
		#GlobalLogger.debug(name,"boss triggered?")
		#wait for boss bar to fill up
		await GlobalSignalBus.boss_bar_filled_up
		#reenable player input
		Player.playerCharacter.disable_input=false
		Player.playerCharacter.stop=false
