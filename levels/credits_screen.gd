#@tool
extends Node2D
var creditsFilePath="res://credits.txt"
@export var resetTextInCode:bool=false
@export var resetTextManually:bool=false
@export var scrollSpeed:float=1.0
@export var currentLine:int=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.scroll_active=true
	$RichTextLabel.scroll_to_line(0)
	currentLine=0
	$scroll_Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Engine.is_editor_hint():
		#if resetTextInCode==false and resetTextManually==false:
			#var fileExists=FileAccess.file_exists(creditsFilePath)
			##if fileExists:
				##var creditsContent=FileAccess.get_file_as_string(creditsFilePath)
				##$RichTextLabel.text="[center]"+creditsContent+"[/center]"
			#resetTextInCode=true
		#if resetTextManually==true:
			#resetTextInCode=false
		##print(name,":active on Editor")
	#elif not Engine.is_editor_hint():
		#resetTextInCode=false
		#print(name,":isNotactive on Editor")
	#$RichTextLabel.
	#$RichTextLabel.scroll_to_line(10)
		#if get_tree().current_scene==self:#checks if we've switched to this scene in-game and applies this effect
		$RichTextLabel.global_position.y-=20*delta #moves text up to create Credits Effect
		if Input.is_action_just_pressed("pause"):
			get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")
		#checks bottom of $richTextLabel by getting its global position and adding it to the size of the richtextlabel in the y-axis or from top to down 
		var endYPosition=$RichTextLabel.global_position.y+$RichTextLabel.size.y 
		#print(endYPosition,"    ",$RichTextLabel/ColorRect.global_position.y)
		#if endYPosition<224*1.2:#checks if richtextlabel has crossed the top of the scene and changes scene to the Main Menu
		#print($RichTextLabel.visible)
		await get_tree().create_timer(3).timeout
		if not $RichTextLabel.is_visible_in_tree():
			get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")
			

func _on_scroll_timer_timeout() -> void:
	#currentLine=currentLine+1
	$RichTextLabel.scroll_to_line(currentLine)#$RichTextLabel.line
	#pass
	#currentLine += scrollSpeed
	#$RichTextLabel.scroll_to_line(int(currentLine))


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
		get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")
