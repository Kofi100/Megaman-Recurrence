@tool
extends CharacterBody2D
@export var spawningTime:float=1.0
@export var explosion_time:float=2.0
@export var simulate:bool=false
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	$spawnTimer.wait_time=spawningTime
	if Engine.is_editor_hint():
		if simulate==true:
			if $spawnTimer.is_stopped():
				$spawnTimer.start()
		else:
			$spawnTimer.stop()
	else:
			if $spawnTimer.is_stopped():
				$spawnTimer.start()

func _on_spawn_timer_timeout() -> void:
	
	var explosiveBoxes=preload("res://levels/level_mechanics/explosive_boxes.tscn").instantiate()
	#get_tree().current_scene.add_child(explosiveBoxes)
	var parent_node = get_tree().current_scene if get_tree().current_scene != null else get_tree().root
	if Engine.is_editor_hint():
		var parent=get_parent()
		if parent==null:return
		get_parent().add_child(explosiveBoxes)
		explosiveBoxes.global_position=global_position
	else:
		if GlobalScreenTransitionTimer.is_stopped():
			parent_node.add_child(explosiveBoxes)
			explosiveBoxes.global_position=global_position
	#print(simulate)
