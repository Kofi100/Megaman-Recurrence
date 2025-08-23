extends CharacterBody2D
@onready var animation_tree: AnimationTree = $AnimationTree

enum Rush_Cutscene_State{SPAWN,SPAWN_END,IDLE,SPRING,JET}
@export var current_state:Rush_Cutscene_State=Rush_Cutscene_State.IDLE
@export var cutscene_velocity:Vector2=Vector2.ZERO
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	set_velocity(cutscene_velocity)
	var nomalized_velocity_x=sign(velocity.x)
	animation_tree.set("parameters/idle/blend_position",nomalized_velocity_x)
	animation_tree.set("parameters/rush_jet/blend_position",nomalized_velocity_x)
	animation_tree.set("parameters/spring/blend_position",nomalized_velocity_x)
	match current_state:
		Rush_Cutscene_State.IDLE:
			animation_tree["parameters/playback"].travel("idle")
		Rush_Cutscene_State.SPRING:
			animation_tree["parameters/playback"].travel("spring")
		Rush_Cutscene_State.JET:
			animation_tree["parameters/playback"].travel("rush_jet")
		Rush_Cutscene_State.SPAWN:
			animation_tree["parameters/playback"].travel("spawn")
		Rush_Cutscene_State.SPAWN_END:
			animation_tree["parameters/playback"].travel("spawn_end")
	move_and_slide()
