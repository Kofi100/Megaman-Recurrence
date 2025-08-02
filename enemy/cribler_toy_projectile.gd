extends enemy


const SPEED = 3000.0
const JUMP_VELOCITY = -400.0
#var grav = 980
var frame_number:int=0
var has_targetted_player:bool=false
var is_bouncing_applied:bool=false
func _ready() -> void:
	$AnimatedSprite2D.frame=frame_number
	playerdamagevalue=2
	health=1
	
func _physics_process(delta: float) -> void:
	$CollisionShape2D.disabled=true
	spawn_collectables()
	# Add the gravity.
	calculate_player_distance()
	rotate(3*delta)
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		velocity.y=-5000*delta
		if has_targetted_player==false:
			#if abs(distance_x)
			velocity.x=sign(distance_x)*SPEED*delta
			has_targetted_player=true
	


	move_and_slide()

func _throwtoPlayer(targetPos: Vector2, height: float):
	var grav = 980
	var displacementX = targetPos.x - global_position.x
	var displacementY = targetPos.y - global_position.y
	var newHeight = abs(displacementY) + height

	if displacementY > 0:
		newHeight = height

		#airtime*=0.01

		#velocity=Vector2(displacementX/2,-(displacementY/2))

		#var tween=create_tween()
		#tween.tween_property(self,"velocity",Vector2(velocityX,velocityY),.2)
	var velocityY = -sqrt(2 * grav * newHeight)
	var airtimeUp = sqrt(2 * height / grav)
	var airtimeDown = sqrt(2 * abs(displacementY - height) / grav)

	if displacementY > 0:
		airtimeDown = sqrt(2 * abs(displacementY + height) / grav)
	var airtime = airtimeUp + airtimeDown
	#airtime*=0.01

	var velocityX = displacementX / airtime

	velocity = Vector2(velocityX, velocityY)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
