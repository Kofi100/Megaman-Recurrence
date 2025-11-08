extends enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var main_body_to_go_towards: Node2D
signal has_returned

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var bounce_count: int = 3
var gravity_active: bool = false
var prev_velocity_y: float = 0.0

func _ready() -> void:
	animated_sprite_2d.play("spawn")
	playerdamagevalue = 3

func _physics_process(delta: float) -> void:
	if gravity_active:
		if not is_on_floor():
			velocity.y += get_gravity().y * delta

		var collision = move_and_collide(velocity * delta)
		if collision:
			# Bounce only if hitting floor-like surface
			if collision.get_normal().y < -0.5:
				velocity = velocity.bounce(collision.get_normal())
				bounce_count -= 1
			else:
				# wall hit, just bounce horizontally
				velocity.x = -velocity.x
	#print(bounce_count)
	if bounce_count == 0:
		# Detect top of last bounce
		if prev_velocity_y < 0 and velocity.y > 0:
			gravity_active = false
		if gravity_active==false:
			if main_body_to_go_towards:
				global_position = global_position.lerp(main_body_to_go_towards.global_position, 5 * delta)
				if global_position.distance_to(main_body_to_go_towards.global_position) < 5:
					has_returned.emit()
					queue_free()
			else:
				queue_free()

	prev_velocity_y = velocity.y

func _on_animated_sprite_2d_animation_finished() -> void:
	match animated_sprite_2d.animation:
		"spawn":
			animated_sprite_2d.play("bounce")
			gravity_active = true
			if main_body_to_go_towards:
				if main_body_to_go_towards.distance_x<=0:	#global_position.x < global_position.x:
					velocity.x = -150#100
				else:
					velocity.x = 150#100
			else:
				velocity.x = -150#j#100
			velocity.y = -200
