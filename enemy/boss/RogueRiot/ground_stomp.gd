extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
var triggered_camera_shake:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	animated_sprite_2d.play("stomp")
	

func Exit():
	animated_sprite_2d.stop()
	triggered_camera_shake=false

func Update(delta:float):
	pass

func Physics_Update(delta:float):
	#await get_tree().create_timer(3).timeout
	if animated_sprite_2d.frame==2 and triggered_camera_shake==false:
		GlobalScript.emit_signal("trigger_camera_shake",5,.15)
		if Player.playerCharacter.is_on_floor():
			Player.playerCharacter.stun_temporarily(.5)
		triggered_camera_shake=true
	await animated_sprite_2d.animation_finished
	transition.emit(self,"idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
