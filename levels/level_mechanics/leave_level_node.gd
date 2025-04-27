extends CharacterBody2D
var playerEntered:bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y+=980*delta
	if playerEntered:
		GlobalScript.pause_level_timer()
	move_and_slide()

func _on_detect_player_body_entered(body):
	if body.is_in_group("player"):
		body.leave_timer.start()
		body.leave_timer.wait_time=.5
		body.leave_bool=true
		body.playLeaveBGM=false
		playerEntered=true
		#body.leaving(0.1)
