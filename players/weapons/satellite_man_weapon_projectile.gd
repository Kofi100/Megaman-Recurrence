extends Player_Projectile

#var SPEED: float = 1000  # Lower speed value since we're not multiplying by delta
var target_enemy: Node2D = null  # Will store reference to enemy
var directionInGame: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if is_instance_valid(target_enemy) and target_enemy.is_inside_tree():
		# Calculate direction to current enemy position (not initial position)
		directionInGame = (target_enemy.global_position - global_position).normalized()
	
	# Apply movement
	velocity = directionInGame * SPEED
	move_and_slide()

# Modified to take enemy reference instead of coordinates
func set_target(enemyNode: Node2D):
	target_enemy = enemyNode

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
func is_in_exactly_this_group(node: Node, group_name: String) -> bool:
	var groups = node.get_groups()
	# Must be in exactly one group and that group must match
	return groups.size() == 1 && groups.has(group_name)
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		#var enemyBody=area.get_parent()
		##if is_in_exactly_this_group(enemyBody,"enemy"):
		area.get_parent().health-=damagevalue
		area.get_parent().hasBeenHurt=true
		queue_free()
		#elif enemyBody.is_in_group("enemy_Projectile"):#not is_in_exactly_this_group(enemyBody,"enemy"):
			#enemyBody.queue_free()
			
