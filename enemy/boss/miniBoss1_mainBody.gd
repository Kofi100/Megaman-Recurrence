extends enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready() -> void:
	is_boss=true
	BossDefenseShot2=2
	health=40

func _physics_process(delta: float) -> void:
	# Add the gravity.
	playerdamagevalue=5
	if health<=0:
		$hitBox/CollisionShape2D.disabled=true
		spawn_collectables()
	if $invTimer.is_stopped()==false:
		$hitBox/CollisionShape2D.disabled=true
	elif $invTimer.is_stopped()==true:
		$hitBox/CollisionShape2D.disabled=false
	move_and_slide()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles"):
		if $invTimer.is_stopped()==true:
			$invTimer.start()
