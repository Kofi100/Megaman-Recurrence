extends CharacterBody2D

@export var SPEED = 30000.0
const JUMP_VELOCITY = -400.0
var stopMoving=false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("outlinecolor", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
	$AnimatedSprite2D.material.set_shader_parameter("bodycolori", (Vector4(136.0, 232.0, 255.0, 255.0)) / 255)
	$AnimatedSprite2D.material.set_shader_parameter("bodycolorii", (Vector4(0.0, 98.0, 247.0, 255.0)) / 255)


func _physics_process(delta):
	# Add the gravity.
	if stopMoving==false:
		velocity.y = SPEED * delta
		move_and_slide()


func _on_detect_player_area_entered(area):
	pass  # Replace with function body.
	if area.is_in_group("player_constants_checker_area2d"):
		pass
		
		area.get_parent().anim.play("spawn")
		area.get_parent().anim.visible = true
		$spawnIn.play()
		stopMoving=true
		visible=false
		await $spawnIn.finished
		queue_free()
