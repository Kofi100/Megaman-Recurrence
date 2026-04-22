extends Collectable
var randomChance

var playerCollectedItem:bool=false

func _ready() -> void:
	#bounce_up_upon_spawning()
	$delete_spawnable_timer.start()
	randomChance=randi_range(1,100)
	if randomChance<=5:
		$Sprite2D.frame=13
	else:
		$Sprite2D.frame=10
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and playerCollectedItem==false:
		velocity += get_gravity() * delta
	if delete_spawnable_timer.time_left<delete_spawnable_timer.wait_time/2 and delete_spawnable_timer.time_left>0 :
		blink_timer+=1*delta
		#print(name,': [small_hcapsule:timer:]',timer)
		#print(name,': [small_hcapsule:fmod(timer,0.2):]',fmod(timer,0.2))
		if fmod(blink_timer,0.2)>0.1:
			$Sprite2D.visible=true
		elif fmod(blink_timer,0.2)<0.1:
			$Sprite2D.visible=false

	move_and_slide()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d") and playerCollectedItem==false:
		GlobalScript.lives+=1
		$life_upSound.play()
		$hitbox/CollisionShape2D.set_deferred("disabled",true)
		self.visible=false
		playerCollectedItem=true
		


func _on_delete_spawnable_timer_timeout() -> void:
	queue_free()


func _on_life_up_sound_finished() -> void:
	queue_free()
