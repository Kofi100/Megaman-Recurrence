extends Node
#@onready var animations: AnimatedSprite2D = $animations
@onready var animations: AnimatedSprite2D = $"../animations"

var normal_speed=4950
var slide_speeed=10080
var move_an_inch_speed=2
var last_direction_x=0
