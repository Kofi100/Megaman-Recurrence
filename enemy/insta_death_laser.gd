extends Line2D

@export var laser_length: float = 300  # Final length of laser
@export var laser_speed: float = 15.0  # Speed of expansion
@export var countDownToShoot: float = 1
@export var debugTest: bool = false

@onready var shape: RectangleShape2D = $Area2D/CollisionShape2D.shape
@onready var area_collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var shapecast2d: ShapeCast2D = $RayCast2D2

var start_pos = Vector2.ZERO
var laser_growth = 0.0
var laser_active = false

#This is meant to an invisible to detect player collision with the actual animated laser


func _ready():
	$Timer.wait_time = countDownToShoot + 2
	$repeatDetection.start()
	reset_laser()
	set_process(false)


func _process(delta):
	if laser_active:
		if debugTest == false:
			laser_length = $RayCast2D.get_collision_point().x - global_position.x

		if get_point_count() < 2:
			add_point(start_pos)  # Ensure at least one point exists
			add_point(start_pos)  # Second point for the laser to extend

		if laser_growth < laser_length:
			laser_growth += laser_speed * delta  # Increment size gradually

			# ✅ STEP 1: Update Line2D first (visual part)
			var new_end_pos = Vector2(laser_growth, 0)
			set_point_position(1, new_end_pos)

			# ✅ STEP 2: Set Collision Shape EXACTLY to the last drawn point
			#shape.size.x = laser_growth # Ensures exact matching
			#area_collision.position.x = new_end_pos.x / 2  # Aligns with laser tip
			if scale.x == -1:
				$instaKillStopper/CollisionShape2D.position.x = new_end_pos.x - 10
			elif scale.x == 1:
				$instaKillStopper/CollisionShape2D.position.x = new_end_pos.x + 10
		else:
			# ✅ Final correction
			laser_growth = laser_length
			var final_pos = Vector2(laser_length, 0)
			set_point_position(1, final_pos)
			#shape.size.x = laser_length
			#area_collision.position.x = laser_length / 2


func _on_timer_timeout() -> void:
	add_point(start_pos)
	add_point(start_pos)  # Adds the second point for extension
	laser_active = true
	set_process(true)
	$repeatLaserProj.start()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Timer.start()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	reset_laser()


func _on_repeat_detection_timeout() -> void:
	shapecast2d.enabled = !shapecast2d.enabled


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		pass  # Add logic for player detection if needed


# ✅ Reset everything properly when off-screen
func reset_laser():
	laser_active = false
	$Timer.stop()
	$repeatLaserProj.stop()
	clear_points()
	laser_growth = 0.0
	start_pos = Vector2.ZERO
	shapecast2d.target_position.x = 0
	shape.size.x = 0
	area_collision.position.x = 0
	set_process(false)


func _on_repeat_laser_proj_timeout() -> void:
	var instaKillLaser = preload("res://enemy/original/original_projs/laser_projectile_InstaKill.tscn").instantiate()
	get_parent().add_child(instaKillLaser)
	instaKillLaser.global_position = global_position
	if scale.x == -1:
		instaKillLaser.direction = "left"
	elif scale.x == 1:
		instaKillLaser.direction = "right"


func _on_insta_kill_stopper_area_entered(area: Area2D) -> void:
	if area.is_in_group("instaKillLaser"):
		area.get_parent().queue_free()
