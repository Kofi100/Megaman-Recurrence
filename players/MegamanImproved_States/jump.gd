extends State
@onready var megaman_improved: CharacterBody2D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	get_parent().get_parent().animations.play("jump")
	megaman_improved.velocity.y=-300

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	var direction=Input.get_axis("move_left","move_right")
	megaman_improved.velocity.x=megaman_improved.player_context.normal_speed * direction *_delta

	if megaman_improved.velocity.y<0:
		if Input.is_action_just_released("jump"):
			megaman_improved.velocity.y=0
	if megaman_improved.is_on_floor():
		if direction==0:
			transition.emit(self,"idle")
		else:
			transition.emit(self,"run")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
