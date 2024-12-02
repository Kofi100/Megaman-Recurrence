extends Node2D
signal screen_Ended

# Called when the node enters the scene tree for the first time.
func _ready():
	$lifeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_life_timer_timeout():
	var tween=create_tween()
	tween.tween_property($stuffToMakeDisappear,"modulate",Color(0,0,0,0),1)
	tween.connect("finished",emitScreenEnded)
	#self.tree_entered.connect(_ready)
	#screen_Ended=
func emitScreenEnded():
	screen_Ended.emit()
