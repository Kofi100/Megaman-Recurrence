extends CharacterBody2D
@export var movement=[
	"up","down"
]
var state
func _physics_process(delta: float) -> void:
	match state:
		"up":
			position-=Vector2(0,10)*delta
		"down":
			position+=Vector2(0,10)*delta
		"left":
			position-=Vector2(10,0)*delta
		"right":
			position+=Vector2(10,0)*delta
