extends CharacterBody2D
class_name PowerSwitch
@export_enum("red","yellow","green") var option:String="red"
@export var switchToDeactivate:PowerSwitch
@export var isOn:bool=false
@export var objectToAffect:Array[Node2D]=[]
var previousState
func _ready() -> void:
	$ColorRect.color=option
	

func _physics_process(delta: float) -> void:
	$coolDown_timer.wait_time=.5
	if isOn:
		$ColorRect.color=Color(option,1.0)
	else:
		$ColorRect.color=Color(option,0.5)
	if isOn!=previousState:
		if switchToDeactivate:
			switchToDeactivate.set_state(!isOn)
	if objectToAffect.size()>0:
		for object in objectToAffect:
			if object!=null:
				if "isOn" in object:
					object.isOn=isOn
				if "color" in object:
					object.color=option
	previousState=isOn
	#print(name,":",isOn,":",previousState)



func set_state(state: bool) -> void:
	if isOn != state:
		isOn = state
		previousState = state

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles"):
		if $coolDown_timer.is_stopped():
			isOn=!isOn
			area.get_parent().queue_free()
			$coolDown_timer.start()
