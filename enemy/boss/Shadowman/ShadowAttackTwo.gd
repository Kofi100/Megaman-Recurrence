extends State
@export var shadowman:CharacterBody2D
@export var dashTimer:Timer#
@export var animatedSprite:AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func Enter():
	if dashTimer:
		dashTimer.connect("timeout",TimeOut)
		dashTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Exit():
		dashTimer.disconnect("timeout",TimeOut)

func Physics_Update(delta):
	if shadowman and animatedSprite and dashTimer:
		var distance=GlobalScript.playerposx-shadowman.global_position.x
		if distance<=0:
			pass
			shadowman.velocity.x=-shadowman.DashSpeed*delta
		elif distance>0:
			pass
			shadowman.velocity.x=shadowman.DashSpeed*delta
		animatedSprite.play("Dash")
		if shadowman.is_on_wall():
			transition.emit(self,"ShadowStop")

func TimeOut():
	transition.emit(self,"ShadowStop")
