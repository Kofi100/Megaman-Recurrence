extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var dialogue: Array[String] = []
@export var dialogue_timings: Array[float] = [3.0, 3.0, 3.0, 5.0, 5.0, 5.0, 5.0, 3.0] # Match with dialogue array
@export var triggered: bool = false

var started_dialogue: bool = false
var start_chasing_player: bool = false
var play_once: bool = false
var dialogue_active: bool = false # New state flag

func _ready() -> void:
	$Label.set_text("")
	$AnimatedSprite2D.visible = false

func _physics_process(delta: float) -> void:
	playerdamagevalue = 1000
	health = INF
	
	# Handle dialogue triggering
	if triggered and not dialogue_active:
		start_dialogue_sequence()
	
	# Handle chasing behavior
	if not start_chasing_player:
		$Area2D/CollisionShape2D.disabled = true
	else:
		$Area2D/CollisionShape2D.disabled = false
		if is_instance_valid(Player.playerCharacter) and GlobalScript.health >= 0:
			var direction = (Player.playerCharacter.global_position - global_position).normalized()
			velocity = direction * 7000 * delta
	
	move_and_slide()

func start_dialogue_sequence():
	dialogue_active = true
	triggered = false
	
	# Initial delay
	await get_tree().create_timer(10.0).timeout
	
	# Play dialogue sequence
	for i in range(dialogue.size()-1):
		$Label.set_text(dialogue[i])
		await get_tree().create_timer(dialogue_timings[i]).timeout
	
	# Handle post-dialogue effects
	$Label.set_text(dialogue[7])
	$AnimatedSprite2D.visible = true
	
	# Play sounds if not already playing
	if not $"yOU're taking too long".playing:
		$"yOU're taking too long".play()
	
	await get_tree().create_timer(3.0).timeout
	$Label.set_text("")
	$AnimatedSprite2D.play("default")
	
	if not $lAUGH.playing:
		$lAUGH.play()
	
	# Enable chasing
	start_chasing_player = true
	dialogue_active = false
