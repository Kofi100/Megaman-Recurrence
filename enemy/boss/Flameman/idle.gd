extends State
@onready var flameman: CharacterBody2D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	flameman.animated_sprite_2d.play("idle")
	await get_tree().create_timer(3).timeout
	transition.emit(self,"attack_fire_throw")

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
