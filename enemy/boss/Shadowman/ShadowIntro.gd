extends State
@export var animatedSprite:AnimatedSprite2D
@export var introTimer:Timer
@export var stateEngStopTimer:Timer
@export var introTimerStartOnEntry:bool
signal temporalStopStateEngine
@export var bossMusic:BGM
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
	#GlobalScript.trigger_boss=true
	animatedSprite.play("Intro")
	$"../../HUD_BossBar".FillBarUp.emit()
	$"../../HUD_BossBar".visible=true
	if bossMusic:
		for music in get_tree().current_scene.get_children(true):
			if music is BGM:
				music.stop()
		bossMusic.play()

func AnimationFinish():
	match animatedSprite.animation:
		"Intro":
			if stateEngStopTimer:
				stateEngStopTimer.start()
			transition.emit(self,"ShadowStop")

			#temporalStopStateEngine.emit()
