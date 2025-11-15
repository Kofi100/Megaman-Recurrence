extends Camera2D

@export var shake_intensity: float = 8.0
@export var shake_duration: float = 0.3

var shaking: bool = false
var time_left: float = 0.0
var original_offset: Vector2

func _ready():
	original_offset = offset
	GlobalSignalBus.trigger_camera_shake.connect(start_shake)
	

func start_shake(intensity := shake_intensity, duration := shake_duration):
	shake_intensity = intensity
	shake_duration = duration
	time_left = duration
	shaking = true

func _process(delta):
	if shaking:
		time_left -= delta
		if time_left > 0:
			# random offset each frame
			offset.x = original_offset.x + randf_range(-shake_intensity, shake_intensity)
			offset.y = original_offset.y + randf_range(-shake_intensity, shake_intensity)
		else:
			# reset and stop shaking
			offset = original_offset
			shaking = false
