extends enemy
var shootOutOnSpawn:bool=false
var triggeredBomb:bool=false
var isOnGround:bool=false
var collision
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	playerdamagevalue=2
	collision=move_and_collide(velocity*delta)
	var rayCollide=$RayCast2D.is_colliding() or $RayCast2D2.is_colliding() or $RayCast2D3.is_colliding()
	#isOnGround seems to be glitchy when detecting the florr,so I'm using a raycast
	#if collision:
		#isOnGround=collision.get_normal().dot(Vector2.UP)>0.7
		#if rayCollide:#isOnGround:
			#velocity.y=0
	#else:
			#isOnGround=false
	#print("bomb",isOnGround)
	if shootOutOnSpawn:
		pass
	if not rayCollide:#is_on_floor():
		velocity.y+=9.8#get_gravity().y
		$hitbox/CollisionShape2D.set_deferred("disabled",false)
	elif rayCollide:#isOnGround:
			velocity.y=0
	if not shootOutOnSpawn:
		velocity.y=-50
		shootOutOnSpawn=true
	if rayCollide:#isOnGround: #is_on_floor():#used with move_and_Slide() 
	#also,move_and_slide() >move_and_collide()
		$hitbox/CollisionShape2D.set_deferred("disabled",true)
		if $AnimatedSprite2D.is_playing()==false:
		#if not triggeredBomb:
			$AnimatedSprite2D.play("activate")
			
			triggeredBomb=true
	
	#print(is_on_floor_only(),"..",$AnimatedSprite2D.is_playing())


func _on_animated_sprite_2d_animation_finished() -> void:
	var explosion=preload("res://enemy/boss/mm3_to_10_explosion_radius.tscn").instantiate()
	$AnimatedSprite2D.visible=false
	add_child(explosion)
	explosion.parent=self
	explosion.playerdamagevalue=5
