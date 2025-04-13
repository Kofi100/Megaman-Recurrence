extends Node2D
var robotSelected: int = 1
var robotAllowToSelect: bool = false
signal changeSceneSignal
var selectionDictionary={
	0:false,
	1:true,
	2:false,
	3:true,
	4:false,
	5:true,
	6:false,
	7:true,
	8:true
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$BGM/selectYourRobotMaster.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_tree().set_pause(false)
	#print(GlobalScript.lives)
	if Input.is_action_pressed("die_debug") and Input.is_action_just_pressed("move_up"):
		get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	if robotSelected > 8:
		robotSelected = 0
	elif robotSelected < 0:
		robotSelected = 8
	#robotSelected=clampi(robotSelected,1,4)
	if robotAllowToSelect == false:
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_up"):
			robotSelected -= 1
			$Sounds/switchRobot.play()
			if selectionDictionary.has(robotSelected):
				if selectionDictionary[robotSelected]==false:
					robotSelected-=1
		elif Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_down"):
			robotSelected += 1
			$Sounds/switchRobot.play()
			if selectionDictionary.has(robotSelected):
				if selectionDictionary[robotSelected]==false:
					robotSelected+=1
		
	if Input.is_action_just_pressed("shoot") and robotAllowToSelect == false:
		#need to work on this for new structure
		if robotSelected==1 or robotSelected==3 or robotSelected==5 :
			robotAllowToSelect = true
			$Timers/screenTransTimer.start()
			$BGM/selectYourRobotMaster.stop()
		elif robotSelected == 8:
			get_tree().change_scene_to_file("res://levels/main_Menu_New.tscn")
	if robotSelected==0:
		pass
	else:
		pass
	if robotSelected==1:
		$Node2D/robotMasterAlt5.play("selected")
	else:$Node2D/robotMasterAlt5.play("notSelected")
	if robotSelected==3:
		$Node2D/robotMasterAlt6.play("selected")
	else:$Node2D/robotMasterAlt6.play("notSelected")
	if robotSelected==5:
		$Node2D/robotMasterAlt7.play("selected")
	else:$Node2D/robotMasterAlt7.play("notSelected")
	if robotSelected==7:
		$Node2D/robotMasterAlt8.play("selected")
	else:$Node2D/robotMasterAlt8.play("notSelected")
	if robotSelected==8:
		$SelectArrow.global_position = $Node2D/exit.global_position-Vector2(20,3)
	#match robotSelected:
		#1:
			##$selected.global_position=$Node2D/ColorRect.global_position
			#$Node2D/robotMasterAlt5.play("selected")
			#$Node2D/robotMasterAlt6.play("notSelected")
			#$Node2D/robotMasterAlt7.play("notSelected")
			#$Node2D/robotMasterAlt8.play("notSelected")
		#2:
			##$selected.global_position=$Node2D/ColorRect2.global_position
			#$Node2D/robotMasterAlt5.play("notSelected")
			#$Node2D/robotMasterAlt6.play("selected")
			#$Node2D/robotMasterAlt7.play("notSelected")
			#$Node2D/robotMasterAlt8.play("notSelected")
		#3:
			##$selected.global_position=$Node2D/ColorRect3.global_position
			##$selected.global_position=$Node2D/ColorRect2.global_position
			#$Node2D/robotMasterAlt5.play("notSelected")
			#$Node2D/robotMasterAlt6.play("notSelected")
			#$Node2D/robotMasterAlt7.play("selected")
			#$Node2D/robotMasterAlt8.play("notSelected")
		#4:
			##$selected.global_position=$Node2D/Color .global_positionds
			##$selected.global_position=$Node2D/ColorRect3.global_position
			##$selected.global_position=$Node2D/ColorRect2.global_position
			#$Node2D/robotMasterAlt5.play("notSelected")
			#$Node2D/robotMasterAlt6.play("notSelected")
			#$Node2D/robotMasterAlt7.play("notSelected")
			#$Node2D/robotMasterAlt8.play("selected")
		#5:
			#$Node2D/robotMasterAlt5.play("notSelected")
			#$Node2D/robotMasterAlt6.play("notSelected")
			#$Node2D/robotMasterAlt7.play("notSelected")
			#$Node2D/robotMasterAlt8.play("notSelected")
			#$SelectArrow.global_position = $Node2D/exit.global_position-Vector2(20,3)
	GlobalScript.robotMaster = robotSelected
	if transition and transition.screen_Ended:  #"transition.screen_Ended" incorrect ref to a signal of another scene
		if transition.is_connected("screen_Ended", changeScene) == false:  #("changeSceneSignal",self,"changeScene")==false:
			transition.connect("screen_Ended", changeScene)  #("changeSceneSignal",self,"changeScene")#("changeScene")
	#if transition and transition.robotMaster:
	#pass
	#transition.robotMaster=robotSelected
	if robotSelected != 8:
		$arrowBlinkTimer.stop()
		$SelectArrow.set_visible(false)
	elif robotSelected == 8:
		if $arrowBlinkTimer.is_stopped():
			$arrowBlinkTimer.start()
		#$SelectArrow.set_visible(true)


@export var spriteDict = {}


func select():
	var sprite: AnimatedSprite2D = spriteDict.get(robotSelected)
	if sprite:
		sprite.play("")


func changeScene():
	if robotSelected == 1:
		get_tree().change_scene_to_file("res://levels/test stages/stage_4.tscn")
	if robotSelected == 3:
		get_tree().change_scene_to_file("res://levels/8_robot_stages/shadowman_stage1.tscn")
	if robotSelected == 5:
		get_tree().change_scene_to_file("res://levels/8_robot_stages/iceman_stage.tscn")

var transition


func _on_screen_trans_timer_timeout():
	transition = preload("res://levels/robot_master_display_scene.tscn").instantiate()
	add_child(transition)
	transition.global_position = global_position


func _on_select_your_robot_master_finished():
	$BGM/selectYourRobotMaster.play()


func _on_arrow_blink_timer_timeout() -> void:
	$SelectArrow.visible=!$SelectArrow.visible
