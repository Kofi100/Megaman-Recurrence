extends Node2D
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==1:
			$AnimationPlayer.play("cutscene_2")
			#get_tree().reload_current_scene()
		if event.button_index==2:
			get_tree().reload_current_scene()
