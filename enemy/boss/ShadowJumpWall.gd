extends State
@export var shadowman: CharacterBody2D
@export var animatedSprite2D: AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func Enter() -> void:
	animatedSprite2D.connect("animation_finished", animationFinished)


var dis_x
var hasJumpedAway = false
var direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta) -> void:
	if shadowman:
		dis_x = GlobalScript.playerposx - shadowman.global_position.x
	if hasJumpedAway == false:
		if dis_x > 0:
			shadowman.velocity.x = -8000 * delta
			shadowman.velocity.y = -5000 * delta
			direction = "left"
		elif dis_x < 0:
			shadowman.velocity.x = 8000 * delta
			shadowman.velocity.y = -5000 * delta
			direction = "right"
	hasJumpedAway = true
	if hasJumpedAway == true:
		if shadowman.is_on_wall():
			shadowman.velocity.y = 0
			animatedSprite2D.play("WallThrow")
			if direction == "left":
				shadowman.velocity.x = 4000 * delta
			elif direction == "right":
				shadowman.velocity.x = -4000 * delta


func Exit() -> void:
	if !shadowman.is_on_floor():
		shadowman.velocity.y += shadowman.get_gravity().y * 0.1
	animatedSprite2D.disconnect("animation_finished", animationFinished)


func animationFinished():
	match animatedSprite2D.animation:
		"WallThrow":
			transition.emit(self, "ShadowStop")
