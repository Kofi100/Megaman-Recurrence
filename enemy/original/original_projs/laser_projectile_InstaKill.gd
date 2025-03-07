extends enemy

var SPEED = 40 * 3600.0
@export var direction: String = "left"


func _ready() -> void:
	$Timer.start()


func _physics_process(delta: float) -> void:
	playerdamagevalue = 12
	match direction:
		"left":
			velocity.x = -SPEED * delta
		"right":
			velocity.x = SPEED * delta
	move_and_slide()
	if not $VisibleOnScreenNotifier2D.is_on_screen():
		queue_free()
	#if is_on_wall():
	#queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is TileMap:
		queue_free()


func _on_timer_timeout() -> void:
	$hitbox/CollisionShape2D.disabled = !$hitbox/CollisionShape2D.disabled
