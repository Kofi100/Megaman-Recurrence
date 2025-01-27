extends Node2D
var robotSelected:int=1
var robotAllowToSelect:bool=false
signal changeSceneSignal
# Called when the node enters the scene tree for the first time.
func _ready():
	$BGM/selectYourRobotMaster.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("die_debug") and Input.is_action_just_pressed("move_up"):
		get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	if robotSelected>4:
		robotSelected=1
	elif robotSelected<1:
		robotSelected=4
	#robotSelected=clampi(robotSelected,1,4)
	if robotAllowToSelect==false:
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_up"):
			robotSelected-=1
			$Sounds/switchRobot.play()
		elif Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_down"):
			robotSelected+=1
			$Sounds/switchRobot.play()
	if Input.is_action_just_pressed("pause") and robotAllowToSelect==false:
		robotAllowToSelect=true
		$Timers/screenTransTimer.start()
		$BGM/selectYourRobotMaster.stop()
	match robotSelected:
		1:
			#$selected.global_position=$Node2D/ColorRect.global_position
			$Node2D/robotMaster1.play("Selected")
			$Node2D/robotMaster2.play("notSelected")
			$Node2D/robotMaster3.play("notSelected")
			$Node2D/robotMaster4.play("notSelected")
		2:
			#$selected.global_position=$Node2D/ColorRect2.global_position
			$Node2D/robotMaster1.play("notSelected")
			$Node2D/robotMaster2.play("Selected")
			$Node2D/robotMaster3.play("notSelected")
			$Node2D/robotMaster4.play("notSelected")
		3:
			#$selected.global_position=$Node2D/ColorRect3.global_position
			#$selected.global_position=$Node2D/ColorRect2.global_position
			$Node2D/robotMaster1.play("notSelected")
			$Node2D/robotMaster2.play("notSelected")
			$Node2D/robotMaster3.play("Selected")
			$Node2D/robotMaster4.play("notSelected")
		4:
			#$selected.global_position=$Node2D/Color .global_positionds
			#$selected.global_position=$Node2D/ColorRect3.global_position
			#$selected.global_position=$Node2D/ColorRect2.global_position
			$Node2D/robotMaster1.play("notSelected")
			$Node2D/robotMaster2.play("notSelected")
			$Node2D/robotMaster3.play("notSelected")
			$Node2D/robotMaster4.play("Selected")
	GlobalScript.robotMaster=robotSelected
	if transition and transition.screen_Ended:#"transition.screen_Ended" incorrect ref to a signal of another scene
		if transition.is_connected("screen_Ended",changeScene)==false:#("changeSceneSignal",self,"changeScene")==false:
			transition.connect("screen_Ended",changeScene)#("changeSceneSignal",self,"changeScene")#("changeScene")
	#if transition and transition.robotMaster:
		#pass
		#transition.robotMaster=robotSelected
@export var spriteDict={}
func select():
	var sprite:AnimatedSprite2D=spriteDict.get(robotSelected)
	if sprite:
		sprite.play("")

func changeScene():
	if robotSelected==1:
		get_tree().change_scene_to_file("res://levels/test stages/stage_4.tscn")
	if robotSelected==2:
		get_tree().change_scene_to_file("res://levels/8_robot_stages/shadowman_stage1.tscn")
var transition
func _on_screen_trans_timer_timeout():
	transition=preload("res://levels/robot_master_display_scene.tscn").instantiate()
	add_child(transition);transition.global_position=global_position
	


func _on_select_your_robot_master_finished():
	$BGM/selectYourRobotMaster.play()
