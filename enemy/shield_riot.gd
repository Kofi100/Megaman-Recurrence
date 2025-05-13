extends enemy
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var hasJumped:bool=false
var speed:int=5000
func _ready() -> void:
	playerdamagevalue = 3
	health=5


func _physics_process(delta: float) -> void:
	pass
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
			#$AnimatedSprite2D.play("jumping")
	else:
		hasJumped=false
	if distance_x < 0:
		$AnimatedSprite2D.flip_h = false
	elif distance_x >= 0:
		$AnimatedSprite2D.flip_h = true
	match $AnimatedSprite2D.flip_h:
		false:
			$shield_Riot_shield.global_position=$Marker2D_L.global_position
		true:
			$shield_Riot_shield.global_position=$Marker2D_R.global_position
	move_and_slide()
#print("hello")
func jump_To_Target(delta):
	pass
	var direction=(Vector2(GlobalScript.playerposx,GlobalScript.playerposy)-global_position).normalized()
	velocity.x=direction.x*(speed)*delta
	velocity.y=-20000*delta
