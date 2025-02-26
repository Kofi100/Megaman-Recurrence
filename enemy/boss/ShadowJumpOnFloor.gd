extends State
@export var shadowman: CharacterBody2D
@export var animatedsprite2d: AnimatedSprite2D

var jumpNumber = 0
var hasJumped = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func Enter():
	jumpNumber = 0
	hasJumped = false


func Exit():
	pass


func Physics_Update(delta):
	if !shadowman or !animatedsprite2d:
		return
	if not shadowman.is_on_floor():
		shadowman.velocity.y += shadowman.get_gravity().y * delta
	var disX = GlobalScript.playerposx - shadowman.global_position.x
	if jumpNumber < 5:
		if shadowman.is_on_floor() and hasJumped == false:
			#animatedsprite2d.play("Stop")
			shadowman.velocity.y = -20000 * delta
			shadowman.velocity.x = 0

			jumpNumber += 1
			hasJumped = true
		if not shadowman.is_on_floor():
			if disX <= 0:
				shadowman.velocity.x = -2000 * delta
			elif disX > 0:
				shadowman.velocity.x = 2000 * delta
			animatedsprite2d.play("Jump")
			hasJumped = false
	elif jumpNumber >= 5 and shadowman.is_on_floor():
		animatedsprite2d.play("Jump")
		transition.emit(self, "ShadowStop")
