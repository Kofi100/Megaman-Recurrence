extends Line2D

@export var laser_length: float = 300  # Final length of laser
@export var laser_speed: float = 15.0  # Speed of expansion
@export var countDownToShoot: float = 1
@export var debugTest: bool = false
@onready var shape: RectangleShape2D = $Area2D/CollisionShape2D.shape
var start_pos = Vector2(0, 0)
var end_pos = Vector2(0, 0)
var laser_growth = 0.0


func _ready():
	$Timer.wait_time = countDownToShoot + 2
	$repeatDetection.start()
	shape.size.x = 0
	clear_points()


func _process(delta):
	if debugTest == false:
		laser_length = $RayCast2D.get_collision_point().x - global_position.x
	if get_point_count() < 2:
		add_point(start_pos)  # Add the first point

	if laser_growth < laser_length:
		laser_growth += laser_speed * delta  # Shared growth value

		# Update both Line2D and CollisionShape2D using the same value
		if get_point_count() > 1:
			set_point_position(1, Vector2(laser_growth, 0))  # Line2D extension
		shape.size.x = laser_growth  # Collision shape matches exactly
		$Area2D/CollisionShape2D.position.x = shape.size.x / 2  # Adjust position
	#var current_end = get_point_position(1) if get_point_count() > 1 else start_pos
	#if current_end.x < end_pos.x:
	#current_end.x += laser_speed * delta  # Extend gradually
	#set_point_position(1, current_end)
	##$RayCast2D2.target_position.x = current_end.x
	#if shape.size.x < laser_length:
	#shape.size.x += laser_speed * delta
	#print(shape.size.x)
	#$Area2D/CollisionShape2D.position.x = shape.size.x / 2
	#if $RayCast2D2.get_collider(0) != null and $RayCast2D2.get_collider(0).is_in_group("player"):
	#GlobalScript.health = 0
	##print($RayCast2D2.collision_result[0])
	#for i in $RayCast2D2.collision_result:
	#if $RayCast2D2.collision_result(i) != null and $RayCast2D2.collision_result(i).is_in_group("player"):
	#GlobalScript.health = 0
	#if $RayCast2D3.get_collider()!=null and $RayCast2D3.get_collider().is_in_group("player"):
	#pass
	#if $RayCast2D2.is_colliding():
	#for i in range($RayCast2D2.get_collision_count()):
	#var collider = $RayCast2D2.get_collider(i)
	#if collider and collider.is_in_group("player"):
	#GlobalScript.health = 0


func _on_timer_timeout() -> void:
	add_point(start_pos)  # Start with just the origin
	end_pos = start_pos + Vector2(laser_length, 0)
	set_process(true)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Timer.start()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$Timer.stop()
	clear_points()
	start_pos = Vector2.ZERO
	end_pos = Vector2.ZERO
	$RayCast2D2.target_position.x = 0
	shape.size.x = 0
	$Area2D/CollisionShape2D.position.x = shape.size.x / 2


func _on_repeat_detection_timeout() -> void:
	$RayCast2D2.enabled = !$RayCast2D2.enabled
