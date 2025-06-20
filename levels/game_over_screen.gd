extends Node2D
var menuOption = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BGM.play()
	await  $BGM.finished
	#$BGM.stream=preload("res://assets/music/Game Over Part 2 Intro Ghost_Entity.ogg")
	$BGM2.play()
	await $BGM2.finished
	$BGM2_Loop.play()
	#$BGM.play()
	#$BGM


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#get_tree().set_pause(false)
	#print(menuOption)
	#print(GlobalScript.lastStageEntered)
	#if menuOption==1:
		#$SelectArrow.global_position.x = $robot_Master.global_position.x-20
	match menuOption:
		0:
			#$SelectArrow.global_position.x = $continue.global_position.x-20
			#$SelectArrow.global_position.y=$continue.global_position.y
			$SelectArrow.set_global_position(Vector2($continue.global_position.x-20,$continue.global_position.y))
		1:
			$SelectArrow.set_global_position(Vector2($robot_Master.global_position.x-20,$robot_Master.global_position.y))
		2:
			$SelectArrow.set_global_position(Vector2($exit.global_position.x-20,$exit.global_position.y))
	if Input.is_action_just_pressed("pause"):
		match menuOption:
			0:
				if GlobalScript.lastStageEntered!=null and GlobalScript.lastStageEntered!="":
					get_tree().change_scene_to_file(GlobalScript.lastStageEntered)
			1:
				get_tree().change_scene_to_file("res://levels/robot_master_menu.tscn")
			2:
				get_tree().quit(0)
func _input(event: InputEvent) -> void:
	if event:
		if event.is_action_pressed("move_up"):
			menuOption -= 1
		elif event.is_action_pressed("move_down"):
			menuOption += 1
	menuOption=clampi(menuOption,0,2)
