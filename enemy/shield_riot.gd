extends enemy
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var hasJumped:bool=false
var speed:int=5000
@onready var shield=$shield_Riot_shield
func _ready() -> void:
	playerdamagevalue = 3
	health=2


func _physics_process(delta: float) -> void:
	#writing this to delete this when screen transitions
	#since enemy_spawner cannot handle this well itm
	if not GlobalScreenTransitionTimer.is_stopped():
		queue_free()
	calculate_player_distance()
	spawn_collectables()
	hurtFlash($AnimatedSprite2D)
	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
	if velocity.y>0:
		$AnimatedSprite2D.play("falling")
	elif velocity.y<0:
		$AnimatedSprite2D.play("jumping")
	if is_on_floor():
		if hasJumped==false:
			#velocity.y=-20000*delta
			jump_To_Target(delta)
			hasJumped=true
			pass
			#$AnimatedSprite2D.play("jumping")
	else:
		hasJumped=false
	if distance_x < 0:
		$AnimatedSprite2D.flip_h = false
	elif distance_x >= 0:
		$AnimatedSprite2D.flip_h = true
	#checks if shield is valid before setting position
	if is_instance_valid(shield):
		match $AnimatedSprite2D.flip_h:
			false:
				shield.global_position=$Marker2D_L.global_position
			true:
				shield.global_position=$Marker2D_R.global_position
	move_and_slide()
#print("hello")
func jump_To_Target(delta):
	pass
	var direction=(Vector2(GlobalScript.playerposx,GlobalScript.playerposy)-global_position).normalized()
	velocity.x=direction.x*(speed)*delta
	velocity.y=-20000*delta
