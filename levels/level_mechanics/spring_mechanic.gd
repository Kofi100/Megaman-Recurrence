extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	

	move_and_slide()


func _on_spring_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_Projectile") or area.is_in_group("player_projectiles") or area.is_in_group("enemy"):
		#print("%s : %s entered spring" % [name+"[not needed]",area.get_parent()])
		return
	var body=area.get_parent()
	if body is CharacterBody2D and body!=self  and not body is enemy:
		#print("%s : %s entered spring" % [name,body])
		body.velocity.y=-500


func _on_spring_area_body_entered(body: Node2D) -> void:
	#if body is CharacterBody2D and body!=self:
		#print("%s : %s entered spring" % [name,body])
		#body.velocity.y=-500
	pass
