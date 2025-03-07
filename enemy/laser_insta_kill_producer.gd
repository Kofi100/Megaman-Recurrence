extends CharacterBody2D
@export var speedOfLaser: float = 5000
@export var countDown: float = 1
@export var setdirectionofLaser: String = "right"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _ready() -> void:
	$countDown.wait_time = countDown + 2


func _physics_process(delta: float) -> void:
	#move_and_slide()
	pass


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$countDown.start()


func _on_count_down_timeout() -> void:
	$repeatShootingLaser.start()


func _on_repeat_shooting_laser_timeout() -> void:
	var instaKillLaser = preload("res://enemy/original/original_projs/laser_projectile_InstaKill.tscn").instantiate()
	if setdirectionofLaser == "right":
		instaKillLaser.global_position.x = $Marker2D.global_position.x + 18
	elif setdirectionofLaser == "left":
		instaKillLaser.global_position.x = $Marker2D.global_position.x - 16
	instaKillLaser.global_position.y = $Marker2D.global_position.y
	instaKillLaser.SPEED = speedOfLaser
	instaKillLaser.direction = setdirectionofLaser
	get_parent().add_child(instaKillLaser)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$countDown.stop()
	$repeatShootingLaser.stop()
