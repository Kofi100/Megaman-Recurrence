extends Node2D
var temporalValue_Lives

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	temporalValue_Lives=GlobalScript.lives
	GlobalScript.lives=9


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tree_exiting() -> void:
	GlobalScript.lives=temporalValue_Lives
