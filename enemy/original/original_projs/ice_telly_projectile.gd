extends enemy
var hasLanded: bool = false

@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0
var playedOnce: bool = false


func _physics_process(delta: float) -> void:
	playerdamagevalue = 3
	if hasLanded == false:
		$AnimatedSprite2D.frame = 0
		velocity.y = SPEED * delta

	if hasLanded == true and playedOnce == false:
		$AnimatedSprite2D.play("onFloor")
		velocity.y = 0
		$existTimer.start()
		playedOnce = true

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMap or body is TileMapLayer:
		hasLanded = true


func _on_exist_timer_timeout() -> void:
	queue_free()
