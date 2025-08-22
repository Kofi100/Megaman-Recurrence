extends CharacterBody2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var NORMAL_SPEED=4950

var last_facing_direction_x=0

func _physics_process(delta: float) -> void:
	var idle= !velocity
	if !idle:
		last_facing_direction_x=sign(velocity.x)
		
	
	animation_tree.set("parameters/idle_normal/blend_position",last_facing_direction_x)
	animation_tree.set("parameters/run_normal/blend_position",last_facing_direction_x)
	animation_tree.set("parameters/jump_normal/blend_position",last_facing_direction_x)
	var current_state=animation_tree.get("parameters/StateMachine/current")
	#print(current_state)
	print([velocity.x,last_facing_direction_x])
	
	
	
	move_and_slide()
	#if current_state
func normalize_one_variable(variable):
	variable=variable/abs(variable)
	
func move_to_position(target_x: float, speed: float, delta:float):
	var direction
	if abs(global_position.x - target_x) > 2:  # tolerance
		direction = sign(target_x - global_position.x)
		velocity.x = direction * speed *delta

	if direction != 0:
		animation_tree.set("parameters/conditions/idle_run",true)
		animation_tree.set("parameters/conditions/run_idle",false)
	else:
		animation_tree.set("parameters/conditions/idle_run",false)
		animation_tree.set("parameters/conditions/run_idle",true)

func cutscene_move_to(target_x: float, speed: float) -> void:
	if not is_inside_tree():
		return
	#await get_tree().create_timer(.2).timeout
	while abs(global_position.x - target_x) > 2:
		var direction = sign(target_x - global_position.x)
		velocity.x = direction * speed
		animation_tree.set("parameters/conditions/idle_run", true)
		animation_tree.set("parameters/conditions/run_idle", false)
		#if velocity.x<0:
			#animation_player.play("run_left")
		#if velocity.x>0:
			#animation_player.play("run_right")

		move_and_slide()
		
		await get_tree().physics_frame

	# Stop at target
	velocity.x = 0
	#animation_player.current_animation="idle_left" if last_facing_direction_x<0 else "idle_right"
	animation_tree.set("parameters/conditions/idle_run", false)
	animation_tree.set("parameters/conditions/run_idle", true)
