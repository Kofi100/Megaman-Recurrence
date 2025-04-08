extends CharacterBody2D

@export var arrayOfFanHazardsToEffect: Array[FanHazard]
var isOn: bool = true


func _physics_process(delta: float) -> void:
	#if isOn==true:
	for i in arrayOfFanHazardsToEffect:
		i.isActive = isOn
	#isOn ? $ColorRect.set_color()
	#if isOn==true:
	#$ColorRect.set_color(Color.GREEN)
	#else:
	#$ColorRect.set_color(Color.RED)
	$ColorRect.color = Color.GREEN if isOn else Color.RED
	#basically the tenary operator(? operator) in Godot
	#it works similarly with if true else/elif false.
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles"):
		if isOn == true and $switchStateTimer.is_stopped() == true:
			isOn = false
			$switchStateTimer.start()


func _on_switch_state_timer_timeout() -> void:
	isOn = true
