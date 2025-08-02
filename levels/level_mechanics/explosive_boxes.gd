#@tool
extends enemy

var trigger:bool = false
@onready var explosion_timer: Timer = $explosion_timer

func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(true)

func _physics_process(delta: float) -> void:
	playerdamagevalue=27
	if not Engine.is_editor_hint():
		if not is_on_floor() and GlobalScreenTransitionTimer.is_stopped():
			velocity.y += get_gravity().y * delta
		elif not GlobalScreenTransitionTimer.is_stopped():
			velocity = Vector2.ZERO
	else:
		#if not is_on_floor():
			##velocity.y += get_gravity().y * delta
			#position.y+=900*delta
			#notify_property_list_changed()
		if global_position.y>2000:
			global_position.y=0
		#global_position.y=0
	move_and_slide()

	explosion_timer.wait_time = 2.5
	set_collision_layer_value(1, true)
	$Area2D.set_collision_layer_value(2, false)
	$Area2D.set_collision_mask_value(2,false)
	if trigger:
		if $explosion_timer.is_stopped():
			$explosion_timer.start()

	if not Engine.is_editor_hint():
		move_and_slide()
		if not $VisibleOnScreenNotifier2D.is_on_screen():
			queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("fire_projectile"):
		trigger = true
		area.get_parent().queue_free()
	

func _on_explosion_timer_timeout() -> void:
	var explosion = preload("res://enemy/boss/mm3_to_10_explosion_radius.tscn").instantiate()
	add_child(explosion)
	explosion.parent = self
	explosion.playerdamagevalue = 5

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
