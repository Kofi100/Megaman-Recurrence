extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	animated_sprite_2d.play("spike_ball_release")

func Exit():
	pass

func Update(delta:float):
	pass

func Physics_Update(delta:float):
	var spike_ball=preload("res://enemy/boss/rogue_riot_spike_ball.tscn")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
