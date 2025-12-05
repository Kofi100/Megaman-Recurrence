extends State
@onready var megaman_improved: CharacterBody2D = $"../.."
var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	megaman_improved.animations.play("run")

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	direction=Input.get_axis("move_left","move_right")
	#if Input.is_action_pressed("move_left"):
		#direction=-1
	#elif Input.is_action_pressed("move_right"):
		#direction=1
	#else:
		#direction=0
	megaman_improved.velocity.x=megaman_improved.player_context.normal_speed * direction *_delta
	
	if direction==0:
		transition.emit(self,"idle")
	if Input.is_action_just_pressed("jump") and megaman_improved.is_on_floor():
		transition.emit(self,"jump")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
