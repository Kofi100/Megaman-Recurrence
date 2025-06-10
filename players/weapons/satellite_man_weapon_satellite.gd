extends CharacterBody2D

@export var upDownDirection = false
var enemies_in_range = []
var closest_enemy = null
var scan_cooldown = 0.2
var time_since_last_scan = 0.0
func _ready() -> void:
	$timer/upDownTimer.start()
func _physics_process(delta: float) -> void:
	# Movement code remains the same...
	if upDownDirection:
		velocity.y = -1000 * delta
	else:
		velocity.y = 1000 * delta
	# Optimized enemy scanning
	time_since_last_scan += delta
	if time_since_last_scan >= scan_cooldown:
		find_enemies_in_only_group("enemy")  # Modified this line
		time_since_last_scan = 0.0
	
# Targeting
	if enemies_in_range.size() > 0:
		closest_enemy = find_closest_enemy()
		if $timer/shootTimer.is_stopped():
			$timer/shootTimer.start()
	else:
		closest_enemy = null
		$timer/shootTimer.stop()
	
	move_and_slide()
	# Rest of your physics process...

# New function to find enemies in exactly one specific group
func find_enemies_in_only_group(group_name: String):
	enemies_in_range.clear()
	var potential_enemies = get_tree().get_nodes_in_group(group_name)
	
	for enemyNode in potential_enemies:
		# Check if enemy is ONLY in the specified group
		if is_in_exactly_this_group(enemyNode, group_name):
			enemies_in_range.append(enemyNode)

# Strict group membership check
func is_in_exactly_this_group(node: Node, group_name: String) -> bool:
	var groups = node.get_groups()
	# Must be in exactly one group and that group must match
	return groups.size() == 1 && groups.has(group_name)

# Rest of your existing functions...
func find_closest_enemy():
	var closest = null
	var closest_distance = INF
	
	for enemyNode in enemies_in_range:
		if is_instance_valid(enemyNode) and enemyNode.is_inside_tree():
			var distance = global_position.distance_to(enemyNode.global_position)
			if distance < closest_distance and distance<250:
				closest_distance = distance
				closest = enemyNode
	#print(closest_distance)
	
	return closest

func _on_up_down_timer_timeout() -> void:
	upDownDirection = !upDownDirection
	
func shootAtEnemy():
	if not is_instance_valid(closest_enemy) or not closest_enemy.is_inside_tree():
		return
	if MegamanAndItems.weaponEnergy[6]>0:
		var projectile = preload("res://players/weapons/satellite_man_weapon_projectile.tscn").instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = global_position
		projectile.set_target(closest_enemy)  # Pass the enemy reference instead of coordinates
		MegamanAndItems.weaponEnergy[6]-=4
func _on_shoot_timer_timeout() -> void:
	if is_instance_valid(closest_enemy) and closest_enemy.is_inside_tree() and global_position.distance_to(closest_enemy.global_position)<250:
		shootAtEnemy()
		print(closest_enemy.get_parent().name)
