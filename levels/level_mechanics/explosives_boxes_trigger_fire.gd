extends enemy
var fireDirection="left"
#@export var explosion_time:float
func _ready() -> void:
	health=1
func _physics_process(delta: float) -> void:
	playerdamagevalue=3
	spawn_collectables()
	match fireDirection:
		"left":velocity.x=-1000*delta
		"right":velocity.x=1000*delta
	move_and_slide()
