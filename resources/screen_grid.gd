@tool
extends TileMapLayer
class_name ScreenGrid
@export var GridNumber:int=0
@export var ModulateLevel:int=255
	#:set(value):
		#push_warning("READ ONLY VALUE")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_modulate(Color(get_modulate(),1.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_inside_tree():
		GridNumber=get_used_cells().size()
	#var temp_Modulate=get_modulate()
	#temp_Modulate.a=float(ModulateLevel/255)
	#print(temp_Modulate.a8)
	#print((get_modulate().a))
	#
	#set_modulate(Color(temp_Modulate,float(ModulateLevel/255)))
	#print(get_used_rect().size)
	#note:rect return position and size
	#P:Position,S:Size
	#print(self.get_used_cells().size())
