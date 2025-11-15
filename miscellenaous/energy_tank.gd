extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if not is_on_floor():
		velocity.y+=get_gravity().y*_delta
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GlobalScript.energy_tank_no+=1
		$Sprite2D.visible=false
		#for i in get_children()
		$sound_effect.play()
		for i in $Area2D.get_children():
			if i is CollisionShape2D or i is CollisionPolygon2D:
				i.set_deferred("disabled",true)
		


func _on_audio_stream_player_finished():
	queue_free()
