extends Boss#enemy
func _ready() -> void:
	health=27
	bossCharacter=self
	#is_boss=true

func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	hurtFlash($AnimatedSprite2D)
	playerdamagevalue=5
	#hitbox is enabled if timer is off and vice versa
	#$hitbox.monitoring
	$hitbox_hurt/CollisionShape2D.set_deferred("disabled",!$Timers/hit_cooldown_timer.is_stopped())#= 
	#print($AnimatedSprite2D.animation)
	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
	if distance_x<0:
		$AnimatedSprite2D.flip_h=false
	elif distance_x>=0:
		$AnimatedSprite2D.flip_h=true
	move_and_slide()
#close_distance:40
#middle:95px
#far:>95px


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles"):
		if $Timers/hit_cooldown_timer.is_stopped():
			$Timers/hit_cooldown_timer.start()
