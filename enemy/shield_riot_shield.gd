extends enemy
var grabFlip_HOfParent:bool=false
func _ready() -> void:
	health=5

func _physics_process(delta: float) -> void:
	hurtFlash($AnimatedSprite2D)
	if get_parent()!=null:
		grabFlip_HOfParent=get_parent().animated_sprite_2d.flip_h
		$AnimatedSprite2D.flip_h=grabFlip_HOfParent
	if health<=0:
		if not $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("default")


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles_Main"):
		var damage=area.get_parent().damagevalue
		#if damage<=1:
			#
			#area.get_parent().state="blocked"
			#health+=1
			#$hurt.play()
		#elif damage>1:#damage>=5
		##$AnimatedSprite2D.play("default")
		#not using code below since the main Player projectiles have a code to auto deduct
		#health of enemies 
		#health-=damage
		#area.get_parent().state="blocked"
		
		$hurt.play()
		#$hurt.play()
		#area.get_parent().queue_free()
			#area.get_parent().state="blocked"
			


func _on_animated_sprite_2d_animation_finished() -> void:
	visible=false
	$hitbox/CollisionShape2D.set_deferred("disabled",true)
