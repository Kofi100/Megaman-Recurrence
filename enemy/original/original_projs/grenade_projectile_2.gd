extends Path2D
@export var speed = 500
@export var targetPos: Vector2
var settarget = false
var activateBomb = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_setTarget()
	$PathFollow2D.progress += speed * delta
	if $PathFollow2D.progress_ratio >= 0.999 and activateBomb == false:
		visible = false
		var exp = preload("res://enemy/boss/mm3_to_10_explosion_radius.tscn").instantiate()
		get_parent().add_child(exp)
		exp.global_position = $PathFollow2D/CharacterBody2D.global_position
		exp.parent = self
		exp.scale = Vector2(0.5, 0.5)
		exp.playerdamagevalue = 5
		activateBomb = true


func _setTarget():
	if settarget == false:
		var displacementX = GlobalScript.playerposx - global_position.x
		var displacementY = GlobalScript.playerposy - global_position.y
		targetPos = Vector2(displacementX, displacementY)
		curve.set_point_out(0, Vector2(targetPos.x / 2, -abs(targetPos.x)))
		curve.set_point_position(1, targetPos)
		settarget = true
