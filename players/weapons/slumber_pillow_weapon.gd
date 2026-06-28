extends Player_Projectile


#const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if health<=0:
		queue_free()
	move_and_slide()

var throw_direction: Vector2
var initial_speed: float
var time = 0.0
var initial_position: Vector2
var throw_angle_degree: float
var grav = 980

func _throwProjectile(targetPos: Vector2, height: float):
	var displacementX = targetPos.x - global_position.x
	var displacementY = targetPos.y - global_position.y
	var newHeight = abs(displacementY) + height

	if displacementY > 0:
		newHeight = height
	
	var velocityY = -sqrt(2 * grav * newHeight)
	var airtimeUp = sqrt(2 * height / grav)
	var airtimeDown = sqrt(2 * abs(displacementY - height) / grav)

	if displacementY > 0:
		airtimeDown = sqrt(2 * abs(displacementY + height) / grav)
	var airtime = airtimeUp + airtimeDown
	var velocityX = displacementX / airtime
	velocity = Vector2(velocityX, velocityY)
	
	#if enemy_body:
		#enemy_body.global_position.x+=10
		#enemy_body.global_position.y-=10
	if not $VisibleOnScreenNotifier2D.is_on_screen() and not is_instance_valid(enemy_body) and found_enemy_body:
		queue_free()
	print("present")
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#queue_free()
	pass

var enemy_body:Node2D
var found_enemy_body:bool=false
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") or area.is_in_group("enemy_Projectile"):
		if health>0:
			#health-=area.get_parent().health
			area.get_parent().health-=damagevalue
			area.get_parent().hasBeenHurt=true
			var dust:Node2D=preload("res://players/weapons/slumber_pillow_dust.tscn").instantiate()
			get_tree().current_scene.call_deferred("add_child",dust)
			
			dust.global_position=global_position
			
			#var body:Node2D=area.get_parent()
			#enemy_body=area.get_parent()
			#found_enemy_body=true
			#var dir=velocity.normalized()
			#enemy_body.knockback_velocity=dir*200
			#enemy_body.knockback_velocity.y=-500
			#body.process_mode=Node.PROCESS_MODE_DISABLED

			$hurt_enemy_effect.play()
			await $hurt_enemy_effect.finished
			queue_free()
