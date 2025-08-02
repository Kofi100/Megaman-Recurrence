extends CharacterBody2D
@export_enum("left","right") var fireDirection:String="left"
@export var fire_release_time:float=1.0
@export var explosion_time:float

func _ready() -> void:
	$fire_Release_timer.start()
func _physics_process(delta: float) -> void:
	$fire_Release_timer.wait_time=fire_release_time


func _on_fire_release_timer_timeout() -> void:
	var fire=preload("res://levels/level_mechanics/explosives_boxes_trigger_fire.tscn").instantiate()
	get_tree().current_scene.add_child(fire)
	fire.global_position=global_position
	fire.fireDirection=fireDirection
	#fire.explosion_time=explosion_time
