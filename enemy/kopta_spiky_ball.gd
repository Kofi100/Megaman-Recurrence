extends enemy
var bounces=0
var initializeDirection:bool=false
var isActive:bool=false
var collision
var bounceVelocity:float=-300
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	calculate_player_distance()
	
	if initializeDirection==true:
		if distance_x<0:
			#velocity=Vector2(-70,50)
			state="left"
		else:
			#velocity=Vector2(70,50)
			state="right"
		velocity=Vector2(0,100)
		isActive=true
		$AnimatedSprite2D.play("default")
		initializeDirection=false
	if isActive:
		collision=move_and_collide(velocity*delta)
		if collision:
			
			velocity.y=bounceVelocity
			bounceVelocity+=50
			#var normal = collision.get_normal()
			#velocity = velocity.bounce(normal)
			bounces+=1
			if state=="left":
				velocity.x=-50
			elif state=="right":
				velocity.x=50
	if not collision and isActive:
		velocity.y+=9.8
	if bounces>=5 and isActive==true:
		#queue_free()
		isActive=false
		var explosion=preload("res://enemy/boss/mm3_to_10_explosion_radius.tscn").instantiate()
		add_child(explosion)
		explosion.parent=self

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#queue_free()
	isActive=false
	var explosion=preload("res://enemy/boss/mm3_to_10_explosion_radius.tscn").instantiate()
	add_child(explosion)
	explosion.parent=self
	
