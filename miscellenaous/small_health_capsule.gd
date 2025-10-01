extends CharacterBody2D
@onready var delete_spawnable_timer = $delete_spawnable_timer
var player_is_around:bool=false
var player_collected_capsule:bool=false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var blink_timer:float=0
func _process(delta):
	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
	if delete_spawnable_timer.time_left<delete_spawnable_timer.wait_time/2 and delete_spawnable_timer.time_left>0 :
		blink_timer+=1*delta
		#print(name,': [small_hcapsule:timer:]',timer)
		#print(name,': [small_hcapsule:fmod(timer,0.2):]',fmod(timer,0.2))
		if fmod(blink_timer,0.2)>0.1:
			$Sprite2D.visible=true
		elif fmod(blink_timer,0.2)<0.1:
			$Sprite2D.visible=false
	
	if player_is_around and not player_collected_capsule:
		if GlobalScript.health<GlobalScript.max_health:
			player_collected_capsule=true
			GlobalScript.health+=2
			$Sprite2D.visible=false
			$health_up.play()
			await $health_up.finished
			queue_free()
			
	move_and_slide()

func _on_hitbox_body_entered(_body):
	#if body.is_in_group('player'):
		#GlobalScript.health+=2
		#queue_free()
	pass


func _on_delete_spawnable_timer_timeout():
	pass # Replace with function body.
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		player_is_around=true
		#print(GlobalScript.health<GlobalScript.max_health)



func _on_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		player_is_around=false
