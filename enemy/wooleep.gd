extends enemy
var hasJumped:bool=false
var foundPlayer:bool=false
var jumpSpeedX=5000
var jumpSpeedY=-5760*1.5
var direction="left"
func _ready() -> void:
	$AnimatedSprite2D.play("spawnIn")
	state="spawnIn"
	health=5
	playerdamagevalue=2
	calculate_player_distance()

func _physics_process(delta: float) -> void:
	spawn_collectables()
	calculate_player_distance()
	hurtFlash($AnimatedSprite2D)
	#print(distance_x,direction)
	if foundPlayer==false:
		if distance_x<0:
			direction="left"
			$AnimatedSprite2D.flip_h=false
			#foundPlayer=true
		elif distance_x>=0:
			direction="right"
			$AnimatedSprite2D.flip_h=true
			#foundPlayer=true
		foundPlayer=true
	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
	if direction=="left":
		$AnimatedSprite2D.flip_h=false
	elif direction=="right":
		$AnimatedSprite2D.flip_h=true
	if is_on_wall_only():
		if direction=="left":
			direction="right"
		elif direction=="right":
			direction="left"
	match state:
		"spawnIn":
			velocity.x=0
		"leap":
			pass
	if $AnimatedSprite2D.animation=="leap":
		if $AnimatedSprite2D.frame==0:
			if hasJumped==false and is_on_floor():
				velocity.y=jumpSpeedY*delta
				
				hasJumped=true
			
	if velocity.y>0:
		$AnimatedSprite2D.play("fall")
		
	if is_on_floor() and $AnimatedSprite2D.animation!="spawnIn":
			$AnimatedSprite2D.play("leap")
	if $AnimatedSprite2D.animation!="spawnIn":
		pass
		#await get_tree().create_timer(1).timeout
		if direction=="left":
			velocity.x=-jumpSpeedX*delta
		elif direction=="right":
			velocity.x=jumpSpeedX*delta
	if $AnimatedSprite2D.animation=="fall":
		hasJumped=false
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"spawnIn":
			$AnimatedSprite2D.play("leap")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
