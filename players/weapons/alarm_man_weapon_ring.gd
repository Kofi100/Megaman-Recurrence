extends CharacterBody2D
var releaseSignal:Signal
var speed:float=1000
@export var initialSignalDirection="left"
var changeState:bool=false
var shootOut:bool=false
var changeState2:bool=false
var setAlarmWeaponPosToUp:bool=true
func _ready() -> void:
	if initialSignalDirection=="left":
		rotation_degrees=-30
	elif initialSignalDirection=="right":
		rotation_degrees=30
	#releaseSignal.connect(releaseFunction)


func _physics_process(delta: float) -> void:
	#if releaseSignal.
	if setAlarmWeaponPosToUp==true:
		if initialSignalDirection=="left":
			rotation_degrees=-30
		elif initialSignalDirection=="right":
			rotation_degrees=30
	elif setAlarmWeaponPosToUp==false:
		if initialSignalDirection=="left":
			rotation_degrees=30
		elif initialSignalDirection=="right":
			rotation_degrees=-30
	if changeState==true and shootOut==false:
			if initialSignalDirection=="left":
				rotation_degrees=90
				
			if initialSignalDirection=="right":
				rotation_degrees=90
	elif changeState==true and shootOut==true:
			if initialSignalDirection=="left":
				rotation_degrees=90
				velocity.x=-10000*delta
			elif initialSignalDirection=="right":
				rotation_degrees=90
				velocity.x=10000*delta
		#if setAlarmWeaponPosToUp==true:#shoots up
			#if initialSignalDirection=="left":
				#velocity.x=-10000*delta
				#velocity.y=-10000*delta
			#if initialSignalDirection=="right":
				#velocity.x=10000*delta
				#velocity.y=-10000*delta
		#elif setAlarmWeaponPosToUp==false:#shoots down
			#if initialSignalDirection=="left":
				#velocity.x=-10000*delta
				#velocity.y=10000*delta
			#if initialSignalDirection=="right":
				#velocity.x=10000*delta
				#velocity.y=10000*delta
	move_and_slide()
func releaseFunction():
	changeState=true
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.get_parent().health-=5
		$hitEnemy.play()
		#queue_free()
