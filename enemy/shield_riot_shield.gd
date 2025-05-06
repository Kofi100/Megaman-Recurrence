extends enemy
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles_Main"):
		var damage=area.get_parent().damagevalue
		if damage<5:
			area.get_parent().state="blocked"
		elif damage>=5:
			$AnimatedSprite2D.play("default")
			#area.get_parent().state="blocked"
			


func _on_animated_sprite_2d_animation_finished() -> void:
	visible=false
	$hitbox/CollisionShape2D.set_deferred("disabled",true)
