extends Line2D

@export var laser_length: float = 300  # Final length of laser
@export var laser_speed: float = 15.0  # Speed of expansion
@export var countDownToShoot: float = 1
@export var debugTest: bool = false

@onready var shape: RectangleShape2D = $instaDeathLaserCBody2D/Area2D/CollisionShape2D.shape
@onready var area_collision: CollisionShape2D = $instaDeathLaserCBody2D/Area2D/CollisionShape2D
@onready var shapecast2d: ShapeCast2D = $RayCast2D2  # Using ShapeCast2D for detection

var start_pos = Vector2.ZERO
var laser_growth = 0.0
var laser_active = false

func _ready():
	$Timer.wait_time = countDownToShoot + 2
	$repeatDetection.start()
	reset_laser()
	set_process(false)

func _process(delta):
	
	if laser_active:
		if debugTest == false:
			laser_length = $RayCast2D.get_collision_point().x - global_position.x

		# Ensure we have two points in Line2D
		if get_point_count() < 2:
			add_point(start_pos)
			add_point(start_pos)

		if laser_growth < laser_length:
			laser_growth += laser_speed * delta  # Increment growth rate

			# ✅ STEP 1: Update Line2D FIRST (ensures visual matches collision)
			var new_end_pos = Vector2(laser_growth, 0)
			set_point_position(1, new_end_pos)

			# ✅ STEP 2: Update CollisionShape2D AFTER the Line2D update
			shape.size.x = laser_growth  # Make sure it matches visually
			area_collision.position.x = laser_growth / 2  # Align with laser tip

			# ✅ STEP 3: Update ShapeCast2D for detection
			shapecast2d.target_position.x = laser_growth

		else:
			# ✅ Final correction to prevent overshooting
			laser_growth = laser_length
			set_point_position(1, Vector2(laser_length, 0))
			shape.size.x = laser_length
			area_collision.position.x = laser_length / 2
			shapecast2d.target_position.x = laser_length  # Make sure ShapeCast2D is accurate

func _on_timer_timeout() -> void:
	add_point(start_pos)
	add_point(start_pos)  # Add second point to extend laser
	laser_active = true
	set_process(true)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Timer.start()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	reset_laser()

func _on_repeat_detection_timeout() -> void:
	shapecast2d.enabled = !shapecast2d.enabled  # Toggle ShapeCast2D detection

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		#GlobalScript.health-=27pa
		pass
		#$instaDeathLaserCBody2D/Area2D/CollisionShape2D.set_deferred("disabled",true)


func reset_laser():
	laser_active = false
	$Timer.stop()
	clear_points()
	laser_growth = 0.0
	start_pos = Vector2.ZERO
	shapecast2d.target_position.x = 0  # Reset ShapeCast2D position
	shape.size.x = 0
	area_collision.position.x = 0
	set_process(false)
