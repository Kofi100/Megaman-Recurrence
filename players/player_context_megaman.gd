extends Player_Context
#@onready var animations: AnimatedSprite2D = $animations
@onready var animations: AnimatedSprite2D = $"../animations"

@export var normal_speed=4950
@export var slide_speed=10080
@export var move_an_inch_speed=2
@export var last_direction_x=0
@export var is_attacking:bool=false

var animation_request = ""
var animation_priority = -1


func _physics_process(_delta: float) -> void:
	#GlobalLogger.debug(name,"is_attacking:%s"%is_attacking)
	pass

func request_animation(anim_name: String, priority: int):
	if priority >= animation_priority:
		animation_request = anim_name
		animation_priority = priority
