extends CharacterBody2D
@onready var delete_spawnable_timer = $delete_spawnable_timer

@onready var animation_player = $AnimationPlayer
var blink_timer:float=0
const JUMP_VELOCITY = -400.0
var player_is_around:bool=false
var player_collected_capsule:bool=false
func _ready():
	#animation_player.set_autoplay('active')
	pass
	
func _process(delta):
	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
	
	if delete_spawnable_timer.time_left>0 and delete_spawnable_timer.time_left<delete_spawnable_timer.wait_time/2:
		blink_timer+=1*delta
		if fmod(blink_timer,0.2)>0.1:
			$Sprite2D.visible=true
		elif fmod(blink_timer,0.2)<0.1:
			$Sprite2D.visible=false
	if player_is_around and not player_collected_capsule:
		#if GlobalScript.health<GlobalScript.max_health:
			player_collected_capsule=true
			GlobalScript.health+=10
			$Sprite2D.visible=false
			$health_up.play()
			await $health_up.finished
			queue_free()
	move_and_slide()

func _on_hitbox_body_entered(_body):
	pass # Replace with function body.
	#if body.is_in_group('player'):
		#GlobalScript.health+=10
		#queue_free()


func _on_delete_spawnable_timer_timeout():
	pass # Replace with function body.
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		player_is_around=true



func _on_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		player_is_around=false
