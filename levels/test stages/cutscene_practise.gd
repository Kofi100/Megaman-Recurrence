extends Node2D
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==1:
		$AnimationPlayer.play("cutscene_1")
