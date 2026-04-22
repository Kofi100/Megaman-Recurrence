extends Collectable
var energy_added=2

func _ready() -> void:
	#bounce_up_upon_spawning()
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity+=get_gravity()*delta
		
	if delete_spawnable_timer.time_left<delete_spawnable_timer.wait_time/2 and delete_spawnable_timer.time_left>0 :
		blink_timer+=1*delta
		if fmod(blink_timer,0.2)>0.1:
			$Sprite2D.visible=true
		elif fmod(blink_timer,0.2)<0.1:
			$Sprite2D.visible=false
	if player_is_around and not player_collected_capsule:
		if GlobalScript.weapon_number>=0:
			if MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]<27:
				player_collected_capsule=true
				MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]+=energy_added
				if MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]>27:
					MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]=27
				$Sprite2D.visible=false
				$weapon_up.play()
				await $weapon_up.finished
				queue_free()
	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.is_in_group('player'):
		pass


func _on_delete_spawnable_timer_timeout():
	pass # Replace with function body.
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		player_is_around=true

		#match GlobalScript.weapon_number:
			#1:
				#MegamanAndItems.weapon1energy+=energy_added
			#2:
				#MegamanAndItems.weapon2energy+=energy_added
		


func _on_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		player_is_around=false
