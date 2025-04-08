extends enemy
var direction:String
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED = 5500*2
const JUMP_VELOCITY = -400.0
func _ready() -> void:
	if direction=="left":
		animated_sprite_2d.flip_h=false
	elif direction=="right":
		animated_sprite_2d.flip_h=true

func _physics_process(delta: float) -> void:
	playerdamagevalue=4
	match direction:
		"left":
			velocity.x=-SPEED*delta
			animated_sprite_2d.flip_h=false
		"right":
			velocity.x=SPEED*delta
			animated_sprite_2d.flip_h=true
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
