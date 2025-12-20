extends State
@onready var megaman_improved: CharacterBody2D = $"../.."
@onready var player_context_megaman: Node2D = $"../../player_context_megaman"

var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	pass

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	var context=megaman_improved.player_context
	direction=Input.get_axis("move_left","move_right")
	#if Input.is_action_pressed("move_left"):
		#direction=-1
	#elif Input.is_action_pressed("move_right"):
		#direction=1
	#else:
		#direction=0
	megaman_improved.velocity.x=context.normal_speed * direction *_delta
	if (not context.is_attacking or 
	(megaman_improved.animations.animation=="shoot_in_air" or megaman_improved.animations.animation=="move_by_inch")):
		#megaman_improved.animations.play("run")
		megaman_improved.player_context.request_animation("run",50)
	if direction==0:
		transition.emit(self,"idle")
	
	if megaman_improved.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			transition.emit(self,"jump")
		if Input.is_action_just_pressed("dash"):
			transition.emit(self,"slide")
	else:
		transition.emit(self,"fall")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
