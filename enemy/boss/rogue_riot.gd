extends Boss#enemy
var activated:bool=false
var activated_hitboxes:bool=false
func _ready() -> void:
	health=27
	bossCharacter=self
	#is_boss=true
var deactivate_gravity:bool=false
func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	#print($Timers/hit_cooldown_timer.wait_time)
	hurtFlash($AnimatedSprite2D)
	playerdamagevalue=5
	#print($Timers/hit_cooldown_timer.time_left)
	#hitbox is enabled if timer is off and vice versa
	#$hitbox.monitoring
	$hitbox_hurt/CollisionShape2D.set_deferred("disabled",!$Timers/hit_cooldown_timer.is_stopped())#= 
	#print($AnimatedSprite2D.animation)
	if not deactivate_gravity:
		if not is_on_floor():
			velocity.y+=get_gravity().y*delta
	if is_on_floor():
		if distance_x<0:
			$AnimatedSprite2D.flip_h=false
		elif distance_x>=0:
			$AnimatedSprite2D.flip_h=true
	move_and_slide()
	#was meant to code for a longer-lasting flashing invincibility effect
	#if hasBeenHurt:
		#var fmod_time=fmod($Timers/hit_cooldown_timer.time_left,0.1)
		#if (int(fmod_time)%2)==0:
			#$AnimatedSprite2D.visible=true
		#elif (int(fmod_time)%2)==1:
			#$AnimatedSprite2D.visible=false
	#else:
		#pass
	if not activated:
		$hitbox/CollisionShape2D.set_deferred("disabled",true)
		$hitbox_hurt/CollisionShape2D.set_deferred("disabled",true)
	else:
		if not activated_hitboxes:
			if $hitbox/CollisionShape2D.disabled:
				$hitbox/CollisionShape2D.set_deferred("disabled",false)
			if $hitbox_hurt/CollisionShape2D.disabled:
				$hitbox_hurt/CollisionShape2D.set_deferred("disabled",false)
			activated_hitboxes=true
#Distance parameters
#close_distance:40
#middle:95px
#far:>95px


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles"):
		if $Timers/hit_cooldown_timer.is_stopped():
			$Timers/hit_cooldown_timer.start()
