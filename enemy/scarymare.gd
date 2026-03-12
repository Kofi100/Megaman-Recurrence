extends enemy

@export var speed: float = 120.0
@export var reengage_distance: float = 150.0  # distance before turning back
@export var player_path: NodePath

var player: Node2D
var move_direction: Vector2
var default_animation_randomizer:int
var default_animation="default"

func _ready():
	player = Player.playerCharacter
	#move_direction = Vector2.ZERO
	health=3
	playerdamagevalue=2
	default_animation_randomizer=randi_range(0,2)
	match default_animation_randomizer:
		0: default_animation="default"
		1: default_animation = "default2"
		2: default_animation = "default3"
	$AnimatedSprite2D.play(default_animation)
	await get_tree().create_timer(.1).timeout
	var to_player = player.global_position - global_position
	#move_direction = to_player.normalized()
	move_direction = move_direction.lerp(to_player.normalized(), 0.1).normalized()

	
	
func _physics_process(_delta):
	if player == null:
		GlobalLogger.warn(name,"player cannot be found")
		return
	if not GlobalScript. slumbshade_darkness_active:
		queue_free()
		return
	if health<=0:
		health=0
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		if $stun_cooldown_timer.is_stopped():
			$stun_cooldown_timer.start()
			$AnimatedSprite2D.play("stun")
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()
	$AnimatedSprite2D.play(default_animation)
	# Only re-aim if we are far enough
	if distance > reengage_distance:
		#move_direction = to_player.normalized()
		move_direction = move_direction.lerp(to_player.normalized(), 0.1).normalized()
	
	if velocity.x>0:$AnimatedSprite2D.flip_h=true
	else:$AnimatedSprite2D.flip_h=false
	
	
		
	
	velocity = move_direction * speed #*delta
	move_and_slide()


func _on_stun_cooldown_timer_timeout() -> void:
	health=3
	$Area2D/CollisionShape2D.set_deferred("disabled",false)
