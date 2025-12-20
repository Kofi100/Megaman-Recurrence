extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	_throwAway(Vector2(30,10),50)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _throwAway(targetPos: Vector2, height: float):
	var displacementX = targetPos.x - global_position.x
	var displacementY = targetPos.y - global_position.y
	var newHeight = abs(displacementY) + height

	if displacementY > 0:
		newHeight = height

		#airtime*=0.01

		#velocity=Vector2(displacementX/2,-(displacementY/2))

		#var tween=create_tween()
		#tween.tween_property(self,"velocity",Vector2(velocityX,velocityY),.2)
	var velocityY = -sqrt(2 * get_gravity().y * newHeight)
	var airtimeUp = sqrt(2 * height / get_gravity().y)
	var airtimeDown = sqrt(2 * abs(displacementY - height) / get_gravity().y)

	if displacementY > 0:
		airtimeDown = sqrt(2 * abs(displacementY + height) / get_gravity().y)
	var airtime = airtimeUp + airtimeDown

	var velocityX = displacementX / airtime
	velocity = Vector2(velocityX, velocityY)
