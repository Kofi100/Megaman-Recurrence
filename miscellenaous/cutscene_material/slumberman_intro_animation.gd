@tool
extends Node2D
#@onready var tween=create_tween()
var base_y: float
@export var float_speed: float = 2.0
@export var float_height: float = 20.0
var time_passed: float = 0.0
var has_played_intro:bool=false
@export var target_position:Marker2D
signal silly_bed_intro_complete

@export var preview_points: int = 30  # number of dots to preview
@export var preview_range: float = 3.0  # how many seconds ahead to show
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	if not Engine.is_editor_hint():
		$AnimatedSprite2D.play("silly_bed_entrance")
		base_y=global_position.y

func _draw():
	if Engine.is_editor_hint():
		var base_y = global_position.y
		for i in range(preview_points):
			var t = (i / float(preview_points)) * preview_range
			var y_offset = sin(t * float_speed) * float_height
			var point = Vector2(position.x - 100 * t, base_y + y_offset)
			draw_circle(to_local(point), 2, Color(1, 0.5, 0.2, 0.6))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		float_speed=5
		time_passed += delta * float_speed
		
		match $AnimatedSprite2D.animation:
			"silly_bed_entrance":
				position.y = base_y + sin(time_passed) * float_height
				position.x -= 100*delta
			"intro":
				position.y=base_y
		if target_position:
			var direction_x=abs(target_position.global_position.x-global_position.x)
			#var direction=(target_position.global_position-global_position).normalized()

			#print(target_position.global_position.distance_to(global_position))
			if direction_x<=1.5 and not has_played_intro:
				#position.dot(direction)
			#target_position.global_position.distance_to(global_position)<=30:
				$AnimatedSprite2D.play("intro")
				silly_bed_intro_complete.emit()
				has_played_intro=true
