extends State
#var main_body=get_parent().get_parent()
@onready var megaman_improved: CharacterBody2D = $"../.."
@onready var animations: AnimatedSprite2D = $"../../animations"

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
	var context=megaman_improved.player_context
	megaman_improved.velocity.x=0
	var direction=Input.get_axis("move_left","move_right")
	if (not context.is_attacking or 
	((animations.animation=="shoot_in_air" or animations.animation=="jump"))):
		#megaman_improved.animations.play("idle")
		megaman_improved.player_context.request_animation("idle",10)
		#GlobalLogger.debug(name,"ondition fulfilled")
	
	#if Input.is_action_just_pressed("move_left") 
	if direction!=0:
		context.last_direction_x=direction
		transition.emit(self,"move_an_inch")
	if megaman_improved.is_on_floor():
		if Input.is_action_just_pressed("jump") :
			transition.emit(self,"jump")
		if Input.is_action_just_pressed("dash"):
			transition.emit(self,"slide")
