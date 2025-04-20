@tool
extends AnimatedSprite2D
class_name CustomAnimatedSprite2D
@export var stopTimer:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$change.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flip_h:
		pass
	if stopTimer==true:
		$change.stop()
	else:
		if $change.is_stopped():
			$change.start()

func changeAnimation(animationName:String,start_at_Frame:int,offset_valueX:int,offset_valueY:int):
	var sf=sprite_frames
	if sf.has_animation(animationName):
		if animation!=animationName:
			animation = animationName
			offset=Vector2(offset_valueX,offset_valueY)
			#frame = clamp(start_at_Frame, 0, sf.get_frame_count(animationName) - 1)
			frame=start_at_Frame
			play()


func _on_change_timeout() -> void:
	if animation=="idle":
		changeAnimation("shoot_idle",0,-3,0)
	else:
		changeAnimation("idle",0,0,0)
