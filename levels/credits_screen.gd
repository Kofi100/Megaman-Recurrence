@tool
extends Node2D
var creditsFilePath="res://credits.txt"
@export var resetTextInCode:bool=false
@export var resetTextManually:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if resetTextInCode==false and resetTextManually==false:
			var fileExists=FileAccess.file_exists(creditsFilePath)
			if fileExists:
				var creditsContent=FileAccess.get_file_as_string(creditsFilePath)
				$RichTextLabel.text="[center]"+creditsContent+"[/center]"
				resetTextInCode=true
		if resetTextManually==true:
			resetTextInCode=false
		print(name,":active on Editor")
	elif not Engine.is_editor_hint():
		resetTextInCode=false
		print(name,":isNotactive on Editor")
	#$RichTextLabel.
