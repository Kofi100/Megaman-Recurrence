extends enemy
@export var stopMoving:bool=false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var shootProjectileOnce:bool=false

func _ready() -> void:
	$Timer.start()

func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	$Timer.wait_time=1.5
	playerdamagevalue=5
	if stopMoving==true:
		velocity.x=0
		#if $Timer.is_stopped()==true:
			#$Timer.start()
	else:
		velocity.x=-3000*delta
		shootProjectileOnce=false
	if $Sprite2D.frame==5 and shootProjectileOnce==false:
		var projectile=preload("res://enemy/original/original_projs/ice_telly_projectile.tscn").instantiate()
		get_parent().add_child(projectile)
		projectile.global_position=global_position
		$shootingSound.play()
		shootProjectileOnce=true
	move_and_slide()


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("shoot")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"shoot":
			$AnimationPlayer.play("default")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
