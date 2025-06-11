@tool
extends TileMapLayer
class_name Conveyor
@export var showCollisions:bool=false
func _process(_delta: float) -> void:
		for node in get_children(true):
			if node is StaticBody2D:
					if Engine.is_editor_hint():
						node.set_visible(true)
					else:
						if showCollisions:
							node.set_visible(true)
						else:
							node.set_visible(false)
