extends enemy
var bounces=0
var initializeDirection:bool=false
var isActive:bool=false
var collision
var bounceVelocity:float=-300
func _ready() -> void:
	playerdamagevalue=2
	health=1
	
func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	if not GlobalScreenTransitionTimer.is_stopped():
		queue_free()
	if initializeDirection==true:
		if distance_x<0:
			#velocity=Vector2(-70,50)
			state="left"
			velocity=Vector2(-50,100)
		else:
			#velocity=Vector2(70,50)
			state="right"
			velocity=Vector2(50,100)
		
		isActive=true
		$AnimatedSprite2D.play("default")
		initializeDirection=false
	if isActive:
		collision=move_and_collide(velocity*delta)
		if collision:
			
			#velocity.y=bounceVelocity
			
			var normal = collision.get_normal()
			velocity = velocity.bounce(normal)
			#bounceVelocity+=50
			velocity=velocity*0.8
			bounces+=1
			#if state=="left":
				#velocity.x=-50
			#elif state=="right":
				#velocity.x=50
	if not collision and isActive:
		velocity.y+=9.8
	if bounces>=5 and isActive==true:
		#queue_free()
		isActive=false
		$AnimatedSprite2D.stop()
		#var explosion=preload("res://enemy/boss/mm3_to_10_explosion_radius.tscn").instantiate()
		#add_child(explosion)
		#explosion.parent=self

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#queue_free()
	pass
	#isActive=false
	#var explosion=preload("res://enemy/boss/mm3_to_10_explosion_radius.tscn").instantiate()
	#add_child(explosion)
	#explosion.parent=self
	
