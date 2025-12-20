extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var rush_spawning_in:bool=true
func _ready() -> void:
	if rush_spawning_in:
		velocity.y=1000
	else:
		velocity.y=-1000


func _physics_process(_delta: float) -> void:
	
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
