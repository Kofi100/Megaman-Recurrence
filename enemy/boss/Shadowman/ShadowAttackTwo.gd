extends State
@export var shadowman: CharacterBody2D
@export var dashTimer: Timer  #
@export var animatedSprite: AnimatedSprite2D
@export var stopTimer: Timer
var dashSet = false


# Called when the node enters the scene tree for the first time.
func Enter():
	if dashTimer:
		dashTimer.connect("timeout", TimeOut)
		dashTimer.start()
	dashSet = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Exit():
	dashTimer.disconnect("timeout", TimeOut)


func Physics_Update(delta):
	if shadowman and animatedSprite and dashTimer:
		var distance = GlobalScript.playerposx - shadowman.global_position.x

		if dashSet == false:
			print("Distance", distance)
			if distance <= 0:  #distance <= -50:
				shadowman.velocity.x = -shadowman.DashSpeed * delta
			elif distance > 0:  #distance > 50:
				shadowman.velocity.x = shadowman.DashSpeed * delta
			animatedSprite.play("Dash")
			dashSet = true
		if abs(distance) <= 70:
			transition.emit(self, "ShadowJumpOnFloor")
		if shadowman.is_on_wall():
			transition.emit(self, "ShadowStop")


func TimeOut():
	#transition.emit(self, "ShadowStop")
	transition.emit(self, "ShadowJumpOnFloor")
	if stopTimer:
		stopTimer.wait_time = 1
