extends State
@onready var megaman_improved: CharacterBody2D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	megaman_improved.velocity.x=megaman_improved.player_context.last_direction_x*megaman_improved.player_context.move_an_inch_speed
	#megaman_improved.animations.play("move_by_inch")
	megaman_improved.player_context.request_animation("move_by_inch",20)
	await get_tree().create_timer(.1).timeout
	transition.emit(self,"run")

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	pass
	var direction=Input.get_axis("move_left","move_right")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
