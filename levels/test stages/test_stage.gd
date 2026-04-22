extends Node2D
#@onready var stage_camera = $all_camera/stage_camera
@onready var player_camera = $megaman/player_camera
@export var universal_canvas_modulate:CanvasModulate

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.spawn_enemy = true
	#$bgm.volume_db=-15
	GlobalScript.set_stage_name("TEST STAGE")
	await $bgm.finished
	#$bgm.stream=preload("res://assets/music/[Spark the Electric Jester OST] 18 - Reynol Complex (Stage 13).mp3")
	$bgm.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

	#print("Value of EngScaleV.Slider:"+$Node2D2/HUD_Debug/EngScaleVSlider.value)
	#StageFunctions.switch_camera(player_camera,stage_camera)
	#StageFunctions.loop_music($bgm,0,354.48)
	#StageFunctions.loop_music($bgm,0,273)
	#print($bgm.get)
	#if tree_exiting():


func _physics_process(_delta):
	Engine.time_scale = $Node2D2/HUD_Debug/EngScaleVSlider.value
	#print($theDarkZone/area.body_entered.emit)


func _on_enter_player_body_entered(body):
	if body.is_in_group("player"):
		pass
		#print("done")
		#StageFunctions.switch_camera(player_camera,stage_camera)


func _on_tree_exiting():
	pass  # Replace with function body.
	Engine.time_scale = 1
	if previous_BGM_Value!=null:
		OptionsSet.data["volumeSound"]["BGM"]=previous_BGM_Value 

var previous_BGM_Value
func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and universal_canvas_modulate:
		var tween = create_tween()
		tween.tween_property(universal_canvas_modulate, "color", Color.BLACK, 0.5)
		await tween.finished
		universal_canvas_modulate.color = Color.BLACK
		$theDarkZone/jackenstein_pumpkin.triggered=true
		previous_BGM_Value=OptionsSet.data["volumeSound"]["BGM"]
		OptionsSet.data["volumeSound"]["BGM"]=-20
		#$bgm.volume_db=0
		#print("area entered")
	


func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and universal_canvas_modulate:
		if $theDarkZone/jackenstein_pumpkin.start_chasing_player==false:
			$theDarkZone/jackenstein_pumpkin.triggered=false
			$theDarkZone/jackenstein_pumpkin.dialogue_active=false
			var tween = create_tween()
			tween.tween_property(universal_canvas_modulate, "color", Color.WHITE, 0.5)
			await tween.finished
			universal_canvas_modulate.color = Color.WHITE
			OptionsSet.data["volumeSound"]["BGM"]=previous_BGM_Value
		#$bgm.volume_db=0
