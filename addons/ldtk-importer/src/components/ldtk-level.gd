@icon("ldtk-level.svg")
@tool
class_name LDTKLevel
extends Node2D

@export var iid: String
@export var world_position: Vector2
@export var size: Vector2i
@export var fields: Dictionary
@export var neighbours: Array
@export var bg_color: Color

func _ready() -> void:
	queue_redraw()
	if Engine.is_editor_hint():
		pass
		var editor_interface = Engine.get_singleton("EditorInterface")
		#var edited_scene = editor_interface.get_edited_scene_root()
		#if edited_scene:
			#var child = edited_scene.get_node("EnemySpawnerInstance") # adjust path
			#if child:
		#editor_interface.get_inspector().edit_node(self)
		#print(self)
		set_editable_instance(self,true)
		
	

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2.ZERO, size), bg_color, false, 2.0)
