extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var enemyVariant: String = "none"
@export var shootPellets: bool = false
var shootOnce:bool=false

#var state:String="idle"
func _ready() -> void:
	match enemyVariant:
		"none":
			$Sprite2D.frame = 0
		"ice":
			$Sprite2D.frame = 5
	health = 5


#var pellet_No = 0


func _physics_process(delta: float) -> void:
	playerdamagevalue = 4
	calculate_player_distance()
	spawn_collectables()
	# Add the gravity.
	$idletoShootTimer.wait_time=.5
	if not is_on_floor():
		velocity += get_gravity() * delta
	if abs(distance_x)<=64:
		#print("DISTANCE REACHED")
		if $idletoShootTimer.is_stopped()==true:
			$idletoShootTimer.start()
	
	#if shootPellets == true:
		#for i in 5:
			#var proj = preload("res://enemy/screw_bomber_projectiles.tscn").instantiate()
			#proj.state = i
			#proj.enemyVariant=enemyVariant
			#get_parent().add_child(proj)
			#proj.global_position = global_position
			#$shootingSound.play()
			##pellet_No = pellet_No + 1
			##print(pellet_No)
	if $Sprite2D.get_frame()==9 and shootOnce==false:
		for i in 5:
			var proj = preload("res://enemy/screw_bomber_projectiles.tscn").instantiate()
			proj.state = i
			proj.enemyVariant=enemyVariant
			get_parent().add_child(proj)
			proj.global_position = global_position
			$shootingSound.play()
		#shootPellets=true
		shootOnce=true
	elif $Sprite2D.get_frame()!=9:
		shootOnce=false
		#shootPellets=false
	#pelletNo should be 15 max to keep performance high.
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	#if $idletoShootTimer.is_stopped() == true:
		#$idletoShootTimer.start()
	pass


func _on_idleto_shoot_timer_timeout() -> void:
	match enemyVariant:
		"none":
			$AnimationPlayer.play("default_Idle_Ready")
		"ice":
			#$AnimatedSprite2D.play("ice")
			$AnimationPlayer.play("ice_Idle_Ready")
			pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#$idletoShootTimer.start()
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$idletoShootTimer.stop()
	queue_free()
