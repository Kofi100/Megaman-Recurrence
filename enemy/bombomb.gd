extends enemy

var happenOnce: bool = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var enemyVariant: String = "none"


func _ready() -> void:
	#$timetoDetonate.start()
	health = 1


func _physics_process(delta: float) -> void:
	$timetoDetonate.wait_time = 15
	velocity.y = -5500 * delta
	playerdamagevalue = 4
	spawn_collectables()
	$AnimatedSprite2D.play(enemyVariant)
	#print(global_position.y-GlobalScript.playerposy)
	if global_position.y - GlobalScript.playerposy < -80 and happenOnce == false:
		queue_free()
		for i in 2:
			var projectile = preload("res://enemy/bombomb_bomb.tscn").instantiate()
			get_parent().add_child(projectile)
			projectile.state = i
			projectile.enemyVariantProjectile = enemyVariant
			projectile.global_position = global_position
		happenOnce = true
	move_and_slide()


func _on_timeto_detonate_timeout() -> void:
	#health = 0
	queue_free()
	for i in 2:
		var projectile = preload("res://enemy/bombomb_bomb.tscn").instantiate()
		get_parent().add_child(projectile)
		projectile.state = i
		projectile.global_position = global_position
