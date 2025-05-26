@tool
extends enemy
@export_enum("shield_riot","dyna_riot") var riotToDeliver:String
var setDirection:bool=false
var enemyIns
var enemyPreview:CharacterBody2D
var startedTimer:bool=false
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#print(riotToDeliver)
	#print(enemyPreview==null)
	if Engine.is_editor_hint():
		match riotToDeliver:
			null:
				if enemyPreview!=null:
					enemyPreview.queue_free()
			"":
				if enemyPreview!=null:
					enemyPreview.queue_free()
			"shield_riot":
				#print("shield")
				if enemyPreview==null:
					enemyPreview=preload("res://enemy/shield_riot.tscn").instantiate()
					enemyPreview.set_physics_process(false)
					add_child(enemyPreview)
					enemyPreview.global_position=$Marker2D.global_position
				#enemyPreview.global_position=global_position
	else:
		$AnimatedSprite2D.play("flying")
		if enemyPreview!=null:
			enemyPreview.queue_free()
		if not startedTimer:
			$Timer.start()
			match riotToDeliver:
				"shield_riot":
					enemyIns=preload("res://enemy/shield_riot.tscn").instantiate()
					enemyIns.set_physics_process(false)
					enemyIns.global_position=$Marker2D.global_position
					get_parent().add_child(enemyIns)
			startedTimer=true
		calculate_player_distance()
		
		if not setDirection:
			if distance_x<0:
				velocity.x=-50
			elif distance_x>=0:
				velocity.x=50
			setDirection=true
		#matc
		if velocity.x<0:
			$AnimatedSprite2D.flip_h=false
		elif velocity.x>=0:
			$AnimatedSprite2D.flip_h=true
		move_and_collide(velocity*delta)


func _on_timer_timeout() -> void:
	if is_instance_valid(enemyIns):
		enemyIns.set_physics_process(true)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
