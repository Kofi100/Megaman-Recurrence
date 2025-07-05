@tool
extends CharacterBody2D
@export var isOn:bool=true
@export var arrayOfLasers:Array[LaserWallMechanic]

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	$switchOnTimer.wait_time=3
	#if isOn:
	for everyLaser in arrayOfLasers:
		if everyLaser!=null:
			everyLaser.isOn=isOn
			$ColorRect.color=Color.GREEN if isOn else Color.RED
		

	move_and_slide()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles"):
		if $switchOnTimer.is_stopped()==true:
			$switchOnTimer.start()
			
			isOn=false
		if area.get_parent().shouldBeDestroyedByLaserSwitch==true:
			area.get_parent().queue_free()


func _on_switch_on_timer_timeout() -> void:
	isOn=true
