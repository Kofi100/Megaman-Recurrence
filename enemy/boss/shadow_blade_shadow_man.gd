extends enemy

const SPEED = 7000.0  #7000
const JUMP_VELOCITY = -400.0
var Shadowman: CharacterBody2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$ShadowBlade.play()
	$Timers/shootToPlayerTimer.start()


var angle_to_shoot: float
var setDirection = false
var setDirectionOnReturn = false


func _physics_process(delta):
	#print(Shadowman.name)
	playerdamagevalue = 5
	if $Timers/shootToPlayerTimer.time_left > 0:
		if setDirection == false:
			#velocity.y = sin(angle_to_shoot) * SPEED * delta
			#velocity.x = cos(angle_to_shoot) * SPEED * delta
			if GlobalScript.playerposx - global_position.x <= 0:
				velocity.x = -SPEED * delta
			if GlobalScript.playerposx - global_position.x > 0:
				velocity.x = SPEED * delta
			setDirection = true

	elif $Timers/shootToPlayerTimer.time_left <= 0 and Shadowman:
		var dis_x = Shadowman.global_position.x - global_position.x
		var dis_y = Shadowman.global_position.y - global_position.y
		#print(dis_x,dis_y)
		var angle_to_return = atan2(dis_y, dis_x)
		#velocity.y = sin(angle_to_return) * SPEED * delta
		#velocity.x = cos(angle_to_return) * SPEED * delta
		if setDirectionOnReturn == false:
			if velocity.x > 0:
				velocity.x = -SPEED * delta
			elif velocity.x <= 0:
				velocity.x = SPEED * delta
			setDirectionOnReturn = true

		#if Shadowman.global_position.x - global_position.x <= 0:
		#velocity.x = SPEED * delta
		#if Shadowman.global_position.x - global_position.x > 0:
		#velocity.x = -SPEED * delta
		if abs(dis_x) <= 20:
			queue_free()
	elif Shadowman and Shadowman.health <= 0:
		queue_free()

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass


func _on_hit_box_area_entered(area):
	#if area.is_in_group("ShadowMan_Boss"):
	#queue_free()
	pass


func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	pass  # Replace with function body.
