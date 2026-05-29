@tool
extends TileMapLayer
class_name Conveyor
@export var showCollisions:bool=false:
	set(value):
		showCollisions = value
		_update_collision_visibility()


func _ready() -> void:
	set_process(false)
	_update_collision_visibility()


func _update_collision_visibility() -> void:
	var visible_in_editor = Engine.is_editor_hint()
	for node in get_children(true):
		if node is StaticBody2D:
			node.visible = visible_in_editor or showCollisions
