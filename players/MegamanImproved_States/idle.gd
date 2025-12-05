extends State
#var main_body=get_parent().get_parent()
@onready var megaman_improved: CharacterBody2D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	#main_body.player_context.norma
	pass

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	pass
	megaman_improved.velocity.x=0
	var direction=Input.get_axis("move_left","move_right")
	megaman_improved.animations.play("idle")
	#if Input.is_action_just_pressed("move_left") 
	if direction!=0:
		megaman_improved.player_context.last_direction_x=direction
		transition.emit(self,"move_an_inch")
	if Input.is_action_just_pressed("jump") and megaman_improved.is_on_floor():
		transition.emit(self,"jump")
