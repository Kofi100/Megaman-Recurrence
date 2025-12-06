extends CharacterBody2D
@export var player_context:Player_Context
#@onready var player_context: Node2D = $player_context_megaman
@onready var animations: AnimatedSprite2D = $animations

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.y = clampf(velocity.y, -420, 420)
	if Input.is_action_pressed("move_left"):
		animations.flip_h=false
	if Input.is_action_pressed("move_right"):
		animations.flip_h=true
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		# apply highest-priority animation request
	if player_context.animation_request != "":
		animations.play(player_context.animation_request)
	
	# reset for next frame
	player_context.animation_request = ""
	player_context.animation_priority = -1
	move_and_slide()
