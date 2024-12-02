extends State
@export var shadowman:CharacterBody2D
@export var stopTimer:Timer
@export var animatedSprite:AnimatedSprite2D
var distance=0
# Called when the node enters the scene tree for the first time.
func Enter():
	pass # Replace with function body.
	attackNo=0
	if stopTimer:
		stopTimer.start()
		stopTimer.connect("timeout",TimeUp)
func Exit():
	stopTimer.disconnect("timeout",TimeUp)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta):
	if shadowman and animatedSprite and stopTimer:
		animatedSprite.play("Stop")
		shadowman.velocity.x=0
		distance=GlobalScript.playerposx-shadowman.global_position.x
var attackNo=0
func TimeUp():
	#print("TimeUp()!")
	
	#match attackNo:
		#0:
		#
		#2: transition.emit(self,"ShadowAttackThree")
	if shadowman.health>13:
		if abs(distance)>128:
			transition.emit(self,"ShadowAttackTwo")
		elif abs(distance)<=128:
			transition.emit(self,"ShadowAttackOne")
	elif shadowman.health<=13:
		if abs(distance)> 128:
			attackNo=randi_range(0,1)
			match  attackNo:
				0:transition.emit(self,"ShadowAttackTwo")
				1:transition.emit(self,"ShadowAttackThree")
		elif abs(distance)<= 128:#192:#why 192?cuase its divisible by 16.
			transition.emit(self,"ShadowAttackOne")
