extends StaticBody2D

@export_enum("Left","Right") var initialDirection="Left"
@export var speedInPixels:float=60.0
func _ready() -> void:
	#constant_linear_velocity.x=1000
	pass

func _physics_process(delta: float) -> void:
	if GlobalScreenTransitionTimer.is_stopped():
		match initialDirection:
			"Left":
				constant_linear_velocity.x=-speedInPixels
			"Right":
				constant_linear_velocity.x=speedInPixels
	else:constant_linear_velocity.x=0
