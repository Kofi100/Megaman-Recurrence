extends CharacterBody2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sfx_base: SFX = $sounds/SFXBase
enum Player_Cutscene_State{IDLE,RUN,JUMP}
@export var current_state:Player_Cutscene_State=Player_Cutscene_State.IDLE
enum Sounds{JUMP}
const Sounds_Paths:={
	Sounds.JUMP:"res://assets/sounds/land.wav"
}
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var NORMAL_SPEED=4950

var last_facing_direction_x=0
@export var cutscene_velocity: Vector2 = Vector2.ZERO
@export var temporal_deacivate_cutscene_velocity:bool=false
@export var in_cutscene: bool = false
var play_sound_once:bool=false
var was_on_floor: bool = true  # remembers last frame state

var has_jumped:bool=false
func _ready() -> void:
	$Sprite2D.material.set_shader_parameter("outlinecolor", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
	$Sprite2D.material.set_shader_parameter("bodycolori", (Vector4(136.0, 232.0, 255.0, 255.0)) / 255)
	$Sprite2D.material.set_shader_parameter("bodycolorii", (Vector4(0.0, 98.0, 247.0, 255.0)) / 255)
func _physics_process(delta: float) -> void:
	#GlobalScript.weapon_number=0
	#MegamanAndItems.change_palette($Sprite2D)
	if not is_on_floor():
		velocity+=get_gravity()*delta
	var idle= !velocity
	if !idle:
		last_facing_direction_x=sign(velocity.x)
		
	
	animation_tree.set("parameters/idle_normal/blend_position",last_facing_direction_x)
	animation_tree.set("parameters/run_normal/blend_position",last_facing_direction_x)
	animation_tree.set("parameters/jump_normal/blend_position",last_facing_direction_x)
	var current_state_playing=animation_tree.get("parameters/StateMachine/current")
	#print(current_state)
	#print([velocity.x,last_facing_direction_x,current_state_playing])
	#if in_cutscene:
	if not temporal_deacivate_cutscene_velocity:
		velocity=cutscene_velocity

	# Update AnimationTree parameter
	match current_state:
		Player_Cutscene_State.IDLE:
			animation_tree["parameters/playback"].travel("idle_normal")
		Player_Cutscene_State.RUN:
			animation_tree["parameters/playback"].travel("run_normal")
		Player_Cutscene_State.JUMP:
			animation_tree["parameters/playback"].travel("jump_normal")
	if current_state==Player_Cutscene_State.JUMP:
		has_jumped=true
	else:
		has_jumped=false
	#
	#if not play_sound_once and is_on_floor() and has_jumped :#and velocity.y>0
		#$sounds/land.play()
		#play_sound_once=true
		#has_jumped=false
	#elif not is_on_floor():
		#play_sound_once=false
# === Landing Sound Logic ===
	if is_on_floor() and not was_on_floor and $ignore_land_timer.is_stopped():
		# Just landed this frame
		$sounds/land.play()

	# Update "last frame" state
	was_on_floor = is_on_floor()
	
	match Sounds:
		Sounds.JUMP:
			sfx_base.stream=preload(Sounds_Paths[Sounds.JUMP])
			
	
	
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
func play_sound_once_function():
	sfx_base.play()
