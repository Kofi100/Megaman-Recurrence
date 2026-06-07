extends Sprite2D
@export var display_ring:bool=false
@export var speed := 20

@export var speed_of_scaling := 1.0
@export var max_scale := 1.5
@export var min_scale := .1
var start_position:Vector2

var expanding := true

func _ready():
	scale = Vector2.ONE
	start_position=global_position

func _process(delta):
	if display_ring:
		visible=false
		return
	global_position-=Vector2(0,speed)*delta 
	var distance=start_position.distance_to(global_position)
	#print(distance)
	#if distance>250:
		#queue_free()
	
	#if expanding:
		#scale += Vector2.ONE * speed_of_scaling * delta
#
		#if scale.x >= max_scale:
			#expanding = false
	#else:
		#scale -= Vector2.ONE * speed_of_scaling * delta
		#if scale.x <= min_scale:
				#expanding = true
		##if scale.x <= 0.1:
			##queue_free()
