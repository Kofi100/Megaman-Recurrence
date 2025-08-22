#@export_tool_button()
@tool
extends CollisionShape2D
class_name AdjustableCollisionShape2D
@export var sizeBy16px_Width: float = 1
@export var sizeBy16px_Height: float = 1


func _process(delta: float) -> void:
	if not shape:
		shape = RectangleShape2D.new()
	if shape:
		#print(shape)
		#print(shape.get_rect().size.x)
		shape.size.x = sizeBy16px_Width * 16
		shape.size.y = sizeBy16px_Height * 16
