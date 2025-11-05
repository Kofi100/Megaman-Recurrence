extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var rogue_riot: CharacterBody2D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.connect("animation_finished",animation_finished_custom)

func Enter():
	animated_sprite_2d.play("spike_ball_release")

func Exit():
	release_spike_ball=false

func Update(delta:float):
	pass
var release_spike_ball:bool=false
func Physics_Update(delta:float):
	#var spike_ball=preload("res://enemy/boss/rogue_riot_spike_ball.tscn")
	if animated_sprite_2d.frame==4 and release_spike_ball==false:
		var spike_ball=preload("res://enemy/boss/rogue_riot_spike_ball.tscn").instantiate()	
		get_tree().current_scene.add_child(spike_ball)
		spike_ball.main_body_to_go_towards=rogue_riot
		spike_ball.global_position=rogue_riot.global_position
		spike_ball.has_returned.connect(spiky_ball_returned)
		animated_sprite_2d.pause()
		release_spike_ball=true
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func animation_finished_custom():
	transition.emit(self,"jump")

func spiky_ball_returned():
	animated_sprite_2d.play()
