extends Node2D
signal screen_Ended
var robotMaster=0
# Called when the node enters the scene tree for the first time.
func _ready():
	robotMaster=GlobalScript.robotMaster
	#print("$displayScene",robotMaster)
	$BGM.play()
	$stuffToMakeDisappear/fireMan.global_position=Vector2(0,-100);$stuffToMakeDisappear/shadowMan.global_position=Vector2(0,-100)
	$stuffToMakeDisappear/nameOfRobotMaster.visible_ratio=0
	match robotMaster:
		0:
			var tween=create_tween()
			#tween.tween_property($stuffToMakeDisappear/fireMan,"position",Vector2(125,101),1.5).from(Vector2(125,0))
			tween.tween_property($stuffToMakeDisappear/fireMan,"position",Vector2(127,110),1).from(Vector2(300,110))
			tween.connect("finished",triggerNameEffect)
			$stuffToMakeDisappear/nameOfRobotMaster.text="FIREMAN"
		1:
			$stuffToMakeDisappear/slumberman_intro_animation.start_animation=true
			$stuffToMakeDisappear/slumberman_intro_animation.silly_bed_intro_complete.connect(triggerNameEffect)
			$stuffToMakeDisappear/nameOfRobotMaster.text="SLUMBERMAN"
		2:
			var tween=create_tween()
			tween.tween_property($stuffToMakeDisappear/shadowMan,"position",Vector2(149,110),1).from(Vector2(300,110))
			tween.connect("finished",triggerNameEffect)
			$stuffToMakeDisappear/nameOfRobotMaster.text="SHADOWMAN"
# Called every frame. 'delta' is the elapsed time since the previous frame.
var previous_visible_char_count := -1

func _process(delta):
	var current_visible = $stuffToMakeDisappear/nameOfRobotMaster.visible_characters
	
	if previous_visible_char_count != current_visible:
		#GlobalLogger.debug(name, "Visible chars changed: %s -> %s" % [previous_visible_char_count, current_visible])
		
		# Play sound when revealing new characters (not when hiding or resetting)
		if current_visible > 0 and current_visible > previous_visible_char_count:
			$SFX.play()
		
		previous_visible_char_count = current_visible
	


func _on_life_timer_timeout():
	pass
	#self.tree_entered.connect(_ready)
	#screen_Ended=
func emitScreenEnded():
	screen_Ended.emit()

func triggerNameEffect():
	var effect=create_tween()
	effect.tween_property($stuffToMakeDisappear/nameOfRobotMaster,"visible_ratio",1.0,1.5).from(0)
	#if robotMaster==1:
		#$stuffToMakeDisappear/fireMan.play("default")


func _on_bgm_finished() -> void:
	#$lifeTimer.start()
	if robotMaster==1:
		await get_tree().create_timer(.5).timeout
	var tween=create_tween()
	tween.tween_property($stuffToMakeDisappear,"modulate",Color(0,0,0,0),1)
	tween.connect("finished",emitScreenEnded)
