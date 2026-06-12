extends enemy
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var kopta_spiky_ball: CharacterBody2D = $koptaSpikyBall

@export var idlespeed:float=2000
@export var triggeredspeed:float=5000
var triggered:bool=false
var speed
var hitPlayer:bool=false
var foundPlayer:bool=false
var playerPos=0
func _ready() -> void:
	health=2
	playerdamagevalue=2
	state="idle"
	
func _physics_process(delta: float) -> void:
	calculate_player_distance()
	spawn_collectables()
	hurtFlash($AnimatedSprite2D)
	if distance_x<0:
		$AnimatedSprite2D.set_flip_h(false)
	else:
		$AnimatedSprite2D.set_flip_h(true)
	match state:
		"idle":
			if abs(distance_x)>5:#abs(distance_x)<=100 and 
				$AnimatedSprite2D.play("idle_Move")
				if distance_x<0:
					velocity.x=-idlespeed*delta
				else:
					velocity.x=idlespeed*delta
			else :
				animated_sprite_2d.play("idle_Still")
				velocity.x=0
		"triggered":
			if abs(distance_x)>5:
				$AnimatedSprite2D.play("triggered_Move")
				#if distance_x<0:
					#velocity.x=-triggeredspeed*delta
				#else:
					#velocity.x=triggeredspeed*delta
			else:
				$AnimatedSprite2D.play("triggered_Still")
				#velocity.x=0
			#var direction: Vector2 = (Vector2(distance_x,distance_y) - global_position).normalized()
			if hitPlayer==false and $retreatTimer.is_stopped():
				#var speedX=move_toward(global_position.x,Player.playerCharacter.global_position.x,100*delta)
				#var speedY=move_toward(global_position.y,Player.playerCharacter.global_position.y,100*delta)
				#global_position.x=speedX
				#global_position.y=speedY
				if foundPlayer==false:
					playerPos=Player.playerCharacter.global_position
					
					#await get_tree().create_timer(.2).timeout
					foundPlayer=true
				global_position=global_position.move_toward(playerPos,300*delta)
				#velocity=direction*triggeredspeed*delta
			else:
				pass
				velocity=Vector2(0,-4000)*delta
				foundPlayer=false
				#if $retreatTimer.is_stopped():
					#$retreatTimer.start()
					#hitPlayer=true
				##velocity=-direction*triggeredspeed*delta
				#var speedX=move_toward(global_position.x,Player.playerCharacter.global_position.x,-100*delta)
				#var speedY=move_toward(global_position.y,Player.playerCharacter.global_position.y,-100*delta)
				#global_position.x=speedX
				#global_position.y=speedY
			if global_position==playerPos:
				if $retreatTimer.is_stopped():
					$retreatTimer.start()
	if is_instance_valid(kopta_spiky_ball):
		if kopta_spiky_ball.bounces>=4:
			if triggered==false:
				if abs(distance_x)>5:
						$AnimatedSprite2D.play("triggered_Move")
				else:
					$AnimatedSprite2D.play("triggered_Still")
				await get_tree().create_timer(.5).timeout
				triggered=true
				state="triggered"
	else:
		if triggered==false:
			if abs(distance_x)>5:
					$AnimatedSprite2D.play("triggered_Move")
			else:
				$AnimatedSprite2D.play("triggered_Still")
			await get_tree().create_timer(.5).timeout
			triggered=true
			state="triggered"
	move_and_slide()


func _on_ball_release_timer_timeout() -> void:
	if is_instance_valid(kopta_spiky_ball):
		kopta_spiky_ball.initializeDirection=true
		kopta_spiky_ball.reparent(get_tree().current_scene)
		#await get_tree().create_timer(3).timeout
		#triggered=true
		#state=triggered
#can you modify my code so that when the enemy gets triggered,it moves towards the player and upon reacing a distance of x=5,y=0 or less,it retreats for some seconds before reattacking


func _on_retreat_timer_timeout() -> void:
	hitPlayer=false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
