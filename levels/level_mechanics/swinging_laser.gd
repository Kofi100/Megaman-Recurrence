@tool
extends LaserWallMechanic

@export var swing_speed: float = 2.0
@export var max_angle: float = 30.0
var time_passed: float = 0.0

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		time_passed += delta * swing_speed
		rotation_degrees = sin(time_passed) * max_angle
	
		if isOn:
			if $RayCast2D.is_colliding():
				var local_hit_position = to_local($RayCast2D.get_collision_point())  #sets CollisionPoint to
				#local Coordiantes for accurate Laser Rendering
				#sets point 1 to local cordiante so that it can render/draw properly
				#even when it s rotated

				$Line2D.set_point_position(1, local_hit_position)  #($RayCast2D.get_collision_point()-global_position))

			move_and_slide()
			if $RayCast2D.get_collider() != null and $RayCast2D.get_collider().is_in_group("player"):
				var player = $RayCast2D.get_collider()

				if GlobalScript.playerhasbeenhit == false:
					GlobalScript.playerhasbeenhit = true
					GlobalScript.health -= 4
					player.anim.play("stun_air")
					if player.stunSound:
						player.stunSound.play()
		else:
			$Line2D.set_point_position(1, Vector2(0, 0))
