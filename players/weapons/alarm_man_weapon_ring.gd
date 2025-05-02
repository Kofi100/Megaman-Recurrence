extends Player_Projectile
var releaseSignal:Signal
#var speed:float=1000
@export var initialSignalDirection="L"
var changeState:bool=false
var shootOut:bool=false
var changeState2:bool=false
var setAlarmWeaponPosToUp:bool=true
var parent_Player
#Player_Projectile.speed=10000
#var damagevalue=5
func _ready() -> void:
	#if initialSignalDirection=="left":
		#rotation_degrees=-30
	#elif initialSignalDirection=="right":
		#rotation_degrees=30
	parent_Player=get_parent()
	match initialSignalDirection:
		"UL","DR":
			rotation_degrees=-30
		"UR","DL":
			rotation_degrees=30
		"L","R":
			set_visible(false)
			if $Area2D/CollisionShape2D.is_inside_tree():
				$Area2D/CollisionShape2D.set_deferred("disabled",true)
			
	#releaseSignal.connect(releaseFunction)


func _physics_process(delta: float) -> void:
	#SPEED=10000
	match initialSignalDirection:
			"UL":
				#gloparent_Player
				global_position=parent_Player.global_position+Vector2(-20,-20)
			"UR":
				global_position=parent_Player.global_position+Vector2(20,-20)
			"DL":
				global_position=parent_Player.global_position+Vector2(-20,20)
			"DR":
				global_position=parent_Player.global_position+Vector2(20,20)

	
	#if releaseSignal.
	if setAlarmWeaponPosToUp==true:
		match initialSignalDirection:
			"UL","DR":
				rotation_degrees=-30
				set_visible(true)
				$Area2D/CollisionShape2D.set_deferred("disabled",false)
			"UR","DL":
				rotation_degrees=30
				set_visible(true)
				$Area2D/CollisionShape2D.set_deferred("disabled",false)
			"L","R":
				rotation_degrees=90
				$Area2D/CollisionShape2D.set_deferred("disabled",true)
				set_visible(false)
			
		#if initialSignalDirection=="left":
			#rotation_degrees=-30
		#elif initialSignalDirection=="right":
			#rotation_degrees=30
		
	elif setAlarmWeaponPosToUp==false:
		#if initialSignalDirection=="left":
			#rotation_degrees=30
		#elif initialSignalDirection=="right":
			#rotation_degrees=-30
		match initialSignalDirection:
			"UL","DR":
				rotation_degrees=-30
				$Area2D/CollisionShape2D.set_deferred("disabled",true)
				set_visible(false)
			"UR","DL":
				rotation_degrees=30
				$Area2D/CollisionShape2D.set_deferred("disabled",true)
				set_visible(false)
			"L","R":
				rotation_degrees=90
				set_visible(true)
				$Area2D/CollisionShape2D.set_deferred("disabled",false)
		match initialSignalDirection:
			"L":
				global_position=parent_Player.global_position+Vector2(0,-20)
			"R":
				global_position=parent_Player.global_position+Vector2(0,20)
	if changeState==true:
		match initialSignalDirection:
			"L":
				rotation_degrees=90
				velocity.x=-SPEED*delta
				set_visible(true)
			"R":
				rotation_degrees=90
				velocity.x=SPEED*delta
				set_visible(true)
			"UL","UR","DL","DR":
				set_visible(false)
				$Area2D/CollisionShape2D.set_deferred("disabled",true)
			#if initialSignalDirection=="left":
				#
			#if initialSignalDirection=="right":
				#rotation_degrees=90
				#velocity.x=SPEED*delta
	#elif changeState==true and shootOut==true:
			#if initialSignalDirection=="left":
				#rotation_degrees=90
				#velocity.x=-10000*delta
			#elif initialSignalDirection=="right":
				#rotation_degrees=90
				#velocity.x=10000*delta
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
	
func is_in_exactly_this_group(node: Node, group_name: String) -> bool:
	var groups = node.get_groups()
	# Must be in exactly one group and that group must match
	return groups.size() == 1 && groups.has(group_name)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var enemyBody=area.get_parent()
		if is_in_exactly_this_group(enemyBody,"enemy"):
			area.get_parent().health-=damagevalue
		elif area.is_in_group("enemy_Projectile"):#not is_in_exactly_this_group(enemyBody,"enemy"):
			enemyBody.queue_free()
		$hitEnemy.play()
		#queue_free()
