@tool
extends AnimatedSprite2D

@export var desiredFPS: float = 5.0
@export var restartAnimation: bool = false
@export var startFrame: int = 0
@export var shouldLoop: bool = true  # Note: used to choose version of anim to play

var isAnimOver = false
var isAnimLooped = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if restartAnimation:
		restartAnimation = false
		# Could trigger animation again here if needed

func startAnim(animName: String, loop: bool = true, start_at_frame: int = 0) -> void:
	var sf = get_sprite_frames()
	if sf and sf.has_animation(animName):
		var finalName = animName
		if !loop:
			finalName = animName + "_once"  # Assume you made a non-looping version in SpriteFrames

		animation = finalName
		frame = clamp(start_at_frame, 0, sf.get_frame_count(finalName) - 1)
		speed_scale = desiredFPS / sf.get_animation_speed(finalName)
		play()
	else:
		push_warning("Animation '%s' not found!" % animName)

func changeAnim(animName: String, loop: bool = true, start_at_frame: int = 0) -> void:
	startAnim(animName, loop, start_at_frame)
