extends Node2D
var setAlarmWeaponPosToUp:bool=true
var changeState:bool=false
func _ready() -> void:
	$timer/switchPosTimer.start()
	$timer/endSessionTimer.start()
func _physics_process(_delta: float) -> void:
	# Check if all rings exist before modifying them
	var rings = [
		$alarm_Man_weapon_Ring,
		$alarm_Man_weapon_Ring2,
		$alarm_Man_weapon_Ring3,
		$alarm_Man_weapon_Ring4,
		$alarm_Man_weapon_Ring5,
		$alarm_Man_weapon_Ring6
	]
	
	for ring in rings:
		if ring and is_instance_valid(ring):
			ring.changeState = changeState
		else:
			# Optional: Print a warning or handle missing rings
			print("Warning: Tried to access a freed/null ring")

	if changeState == true:
		# Check if rings are still children before reparenting
		if is_instance_valid($alarm_Man_weapon_Ring5) and $alarm_Man_weapon_Ring5.get_parent() == self:
			rings.erase($alarm_Man_weapon_Ring5)
			$alarm_Man_weapon_Ring5.reparent(get_tree().current_scene)
			
		if is_instance_valid($alarm_Man_weapon_Ring6) and $alarm_Man_weapon_Ring6.get_parent() == self:
			rings.erase($alarm_Man_weapon_Ring6)
			$alarm_Man_weapon_Ring6.reparent(get_tree().current_scene)
			
		#print(rings[4])
		
	#if rings[4]==null and rings[5]==null:#for ring in rings:
	if rings.find($alarm_Man_weapon_Ring5)==-1 and rings.find($alarm_Man_weapon_Ring6)==-1:
		#chekcings rings4 and 5(L and R rings) since they'll be freed after leavign the screen
		queue_free()

func _on_switch_pos_timer_timeout() -> void:
	setAlarmWeaponPosToUp=!setAlarmWeaponPosToUp
	var rings = [
		$alarm_Man_weapon_Ring,
		$alarm_Man_weapon_Ring2,
		$alarm_Man_weapon_Ring3,
		$alarm_Man_weapon_Ring4,
		$alarm_Man_weapon_Ring5,
		$alarm_Man_weapon_Ring6
	]
	for ring in rings:
		if ring and is_instance_valid(ring):
			if ring.changeState==false:
				ring.setAlarmWeaponPosToUp=setAlarmWeaponPosToUp
			#ring.changeState = changeState
		else:
			# Optional: Print a warning or handle missing rings
			print(name,":Warning: Switch Postion Timer Tried to access a freed/null ring")
	#if $alarm_Man_weapon_Ring.changeState==false:
		#$alarm_Man_weapon_Ring.setAlarmWeaponPosToUp=setAlarmWeaponPosToUp
		#$alarm_Man_weapon_Ring2.setAlarmWeaponPosToUp=setAlarmWeaponPosToUp
		#$alarm_Man_weapon_Ring3.setAlarmWeaponPosToUp=setAlarmWeaponPosToUp
		#$alarm_Man_weapon_Ring4.setAlarmWeaponPosToUp=setAlarmWeaponPosToUp
		#$alarm_Man_weapon_Ring5.setAlarmWeaponPosToUp=setAlarmWeaponPosToUp
		#$alarm_Man_weapon_Ring6.setAlarmWeaponPosToUp=setAlarmWeaponPosToUp


func _on_end_session_timer_timeout() -> void:
	queue_free()
