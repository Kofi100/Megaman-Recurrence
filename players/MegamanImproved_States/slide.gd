extends State
@onready var megaman_improved: CharacterBody2D = $"../.."
@onready var animations: AnimatedSprite2D = $"../../animations"

@onready var dash_timer: Timer = $"../../Timers/dash_timer"
var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	dash_timer.timeout.connect(_dash_timer_timeout)
func Enter():
	animations.play("dash")
	dash_timer.start()
	pass

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	var context=megaman_improved.player_context
	direction=Input.get_axis("move_left","move_right")
	megaman_improved.velocity.x=direction*context.slide_speed*_delta
	if direction==0:
		transition.emit(self,"idle")
	if megaman_improved.is_on_floor():
		if Input.is_action_just_pressed("jump") :
			transition.emit(self,"jump")
	
func _dash_timer_timeout():
	#direction=Input.get_axis("move_left","move_right")
	#if megaman_improved.velocity.x!=0:
		transition.emit(self,"run")
