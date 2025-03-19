extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var grav = 980
var hasBeenThrown: bool = false
#variable used to set Enemy Projectile Look based on the variant of the Enemy that uses it.
@export var enemyVariantProjectile:String="none"

func _physics_process(delta: float) -> void:
	playerdamagevalue = 5
	$AnimatedSprite2D.play(enemyVariantProjectile)
	if not is_on_floor():
		velocity.y += grav * delta
	if hasBeenThrown == false:
		match state:
			0:
				_throwtoPlayer(Vector2(global_position.x - 20, global_position.y), 20)
			1:
				_throwtoPlayer(Vector2(global_position.x + 20, global_position.y), 20)
		hasBeenThrown = true
	move_and_slide()


func _throwtoPlayer(targetPos: Vector2, height: float):
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

		#airtime*=0.01

		#velocity=Vector2(displacementX/2,-(displacementY/2))

		#var tween=create_tween()
		#tween.tween_property(self,"velocity",Vector2(velocityX,velocityY),.2)
	var airtime = airtimeUp + airtimeDown
	#airtime*=0.01

	var velocityX = displacementX / airtime

	#velocity=Vector2(displacementX/2,-(displacementY/2))
	velocity = Vector2(velocityX, velocityY)
