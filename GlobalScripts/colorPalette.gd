@tool
extends Resource
class_name ColorPalette
#@export var colorDictionary:Dictionary={
var LIGHT_VIOLET= Vector4(135.0, 0.0, 142.0, 255.0)
var BLACK= Vector4(0, 0, 0, 255)
var WHITE= Vector4(255, 255, 255, 255)
var LIGHTER_VIOLET= Vector4(251.0, 179.0, 255.0, 255.0)
var LIGHT_BLUE= Vector4(136.0, 232.0, 255.0, 255.0)
var DEEP_BLUE= Vector4(0.0, 98.0, 247.0, 255.0)
var DEEP_RED=Vector4(168.0,0.0,32.0,255.0)
var SLIGHTLY_DEEP_RED=Vector4(228.0,0.0,88.0,255.0)
var LIGHTER_DEEP_RED=Vector4(248.0,88.0,152.0,255.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
