extends CharacterBody2D
@export var upDownDirection=false
var enemies_in_range=[]
var closest_enemy
func _ready() -> void:
	$timer/upDownTimer.start()

#lowkey the codes here are requiring a lot of power to use
#i'll have to find a way to fix them.
func _physics_process(delta: float) -> void:
	find_enemies()
	if upDownDirection==true:
		velocity.y=-1000*delta
	else:
		velocity.y=1000*delta
	if enemies_in_range.size()>0:
		closest_enemy=find_closest_enemy()
		if $timer/shootTimer.is_stopped():
			$timer/shootTimer.start()
		
	else:
		closest_enemy=null
		$timer/shootTimer.stop()
	#print(name,":closest_enemy:",closest_enemy,",:",closest_enemy.get_parent().name)
	move_and_slide()

func find_enemies():
	var allEnemies= get_tree().get_nodes_in_group("enemy")
	for enemies in allEnemies:
		if is_in_only_group(enemies,"enemy"):
			enemies_in_range.append(enemies)
	#for i in enemies_in_range:
		#if i==null:
			#pass
			#var index=enemies_in_range.bsearch(i)
			#enemies_in_range.remove_at(index)
			
	#enemies_in_range =
func find_closest_enemy():
	var closest = null
	var closest_distance = INF
	#var purelyEnemies
	for purelyEnemies in enemies_in_range:
		if purelyEnemies!=null:
			var distance = global_position.distance_to(purelyEnemies.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest = purelyEnemies
	enemies_in_range.clear()
	#clears all enemies in range array after finding the closest one
	
		#for 1 in number=5:
			#print(purelyEnemies)

	
	return closest
func is_in_only_group(node: Node, group_name: String) -> bool:
	var groups = node.get_groups()
	return groups.size() == 1 && groups[0] == group_name

func _on_up_down_timer_timeout() -> void:
	upDownDirection=!upDownDirection
	
func shootAtEnemy():
	var projectile=preload("res://players/weapons/satellite_man_weapon_projectile.tscn").instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position=global_position
	if projectile.IsAimed==false:
		#projectile.
		projectile.enemy_disX=closest_enemy.global_position.x
		projectile.enemy_disY=closest_enemy.global_position.y
		projectile.IsAimed=true
	

func _on_shoot_timer_timeout() -> void:
	shootAtEnemy()
