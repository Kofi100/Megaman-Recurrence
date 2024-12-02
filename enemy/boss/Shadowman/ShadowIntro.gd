extends State
@export var animatedSprite:AnimatedSprite2D
@export var introTimer:Timer
@export var stateEngStopTimer:Timer
@export var introTimerStartOnEntry:bool
signal temporalStopStateEngine
# Called when the node enters the scene tree for the first time.
func Enter():
	pass # Replace with function body.
	if animatedSprite:
		animatedSprite.play("Stop")
		if introTimerStartOnEntry==true:
			introTimer.start()
		introTimer.connect("timeout",TimeOut)
		animatedSprite.connect("animation_finished",AnimationFinish)
func Exit():
	animatedSprite.disconnect("animation_finished",AnimationFinish)
	introTimer.disconnect("timeout",TimeOut)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func  Physics_Update(delta):
	pass
func TimeOut():
	GlobalScript.trigger_boss=true
	animatedSprite.play("Intro")
func AnimationFinish():
	match animatedSprite.animation:
		"Intro":
			transition.emit(self,"ShadowStop")
			if stateEngStopTimer:
				stateEngStopTimer.start()
			#temporalStopStateEngine.emit()
