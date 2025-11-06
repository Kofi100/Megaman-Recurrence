extends enemy
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var main_body_to_go_towards:Node2D
signal has_returned
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var bounce_count:int=5
var gravity_active:bool=false#true
func _ready() -> void:
	animated_sprite_2d.play("spawn")
	playerdamagevalue=3


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if gravity_active:
		if not is_on_floor():
			velocity += get_gravity() * delta

		var collision=move_and_collide(velocity*delta)
		if collision:
			var bounce_velocity=velocity.bounce(collision.get_normal())
			#20% energy loss,80% kept
			velocity=bounce_velocity#*0.9
			bounce_count-=1
	
	if bounce_count==0 or is_on_wall():
		#
		gravity_active=false
		if main_body_to_go_towards:
			global_position=global_position.lerp(main_body_to_go_towards.global_position,5*delta)
			if abs(global_position.distance_to(main_body_to_go_towards.global_position))<5:#global_position==main_body_to_go_towards.global_position:
				has_returned.emit()
				queue_free()
		else:
			queue_free()
	#move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	match  animated_sprite_2d.animation:
		"spawn":
			animated_sprite_2d.play("bounce")
			gravity_active=true
			if main_body_to_go_towards:
				if main_body_to_go_towards.distance_x<0:
					velocity.x=-100
				if main_body_to_go_towards.distance_x>=0:
					velocity.x=100
			else:
				velocity.x=-100
			velocity.y=-200
			
