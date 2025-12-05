extends State
@onready var flameman: CharacterBody2D = $"../.."

#var body=get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	await get_tree().create_timer(5).timeout
	flameman.animated_sprite_2d.play("intro")
	await flameman.animated_sprite_2d.animation_finished
	transition.emit(self,"idle")

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
