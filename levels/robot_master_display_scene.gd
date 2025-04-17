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
	if robotMaster==0:
		var tween=create_tween()
		tween.tween_property($stuffToMakeDisappear/fireMan,"position",Vector2(125,101),1.5).from(Vector2(125,0))
		tween.connect("finished",triggerNameEffect)
		$stuffToMakeDisappear/nameOfRobotMaster.text="FIREMAN"
	if robotMaster==2:
		var tween=create_tween()
		tween.tween_property($stuffToMakeDisappear/shadowMan,"position",Vector2(149,85),1.5).from(Vector2(149,0))
		tween.connect("finished",triggerNameEffect)
		$stuffToMakeDisappear/nameOfRobotMaster.text="SHADOWMAN"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match robotMaster:
		1:
			pass
			


func _on_life_timer_timeout():
	pass
	#self.tree_entered.connect(_ready)
	#screen_Ended=
func emitScreenEnded():
	screen_Ended.emit()

func triggerNameEffect():
	var effect=create_tween()
	effect.tween_property($stuffToMakeDisappear/nameOfRobotMaster,"visible_ratio",1.0,1.5).from(0)
	if robotMaster==1:
		$stuffToMakeDisappear/fireMan.play("default")


func _on_bgm_finished() -> void:
	#$lifeTimer.start()
	var tween=create_tween()
	tween.tween_property($stuffToMakeDisappear,"modulate",Color(0,0,0,0),1)
	tween.connect("finished",emitScreenEnded)
