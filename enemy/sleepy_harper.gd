extends enemy
var shootOnce:bool=false
func _ready() -> void:
	$AnimatedSprite2D.play("playing")
	health=3

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity+=get_gravity()*delta
	calculate_player_distance()
	spawn_collectables()
	if distance_x<0:
		$AnimatedSprite2D.flip_h=false
		$AnimatedSprite2D.set_offset(Vector2(0,0))
		$hitbox/L.disabled=false
		$hitbox/R.disabled=true
	elif distance_x>=0:
		$AnimatedSprite2D.flip_h=true
		$AnimatedSprite2D.set_offset(Vector2(-9,0))
		$hitbox/L.disabled=true
		$hitbox/R.disabled=false
	if $AnimatedSprite2D.frame==1:
		if shootOnce==false:
			var proj=preload("res://enemy/sleepy_harper_projectile.tscn").instantiate()
			proj.position=position
			get_tree().current_scene.add_child(proj)
			shootOnce=true
	else:shootOnce=false

func _on_shoot_projectile_timeout() -> void:
	pass
