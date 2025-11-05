extends State
@onready var laser_attack_visual: Line2D = $"../../laser_attack_visual"
@onready var laser_attack_raycast_2d: RayCast2D = $"../../laser_attack_raycast2d"
@onready var main_animation_player: AnimationPlayer = $"../../main_animation_player"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var rogue_riot: CharacterBody2D = $"../.."

var laser_affect_player:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	main_animation_player.play("RESET")
	laser_attack_visual.global_rotation = laser_attack_raycast_2d.global_rotation
	laser_attack_visual.global_position = laser_attack_raycast_2d.global_position
	#animation_finished provides and carried the anim_name argument to 
	#what function you want to use.
	laser_attack_visual.visible=false
	laser_attack_raycast_2d.visible=false
	main_animation_player.connect("animation_finished",animation_finished_function)#.bind(main_animation_player.anim_name)
	animated_sprite_2d.connect("animation_finished",rogue_animation_finished)
func Enter():

	animated_sprite_2d.play("laser")
	
	

func Exit():
	laser_attack_visual.visible=false
	#laser_attack_visual.visible=true
	laser_affect_player=false
	main_animation_player.play("RESET")

func Update(delta:float):
	pass

func Physics_Update(delta:float):
	laser_attack_visual.global_rotation = laser_attack_raycast_2d.global_rotation
	laser_attack_visual.global_position = laser_attack_raycast_2d.global_position
		#laser_attack_visual.rotation_degrees=laser_attack_raycast_2d.rotation_degrees
	if laser_attack_raycast_2d.is_colliding():
		var local_hit_position = laser_attack_raycast_2d.to_local(laser_attack_raycast_2d.get_collision_point())  #sets CollisionPoint to
		laser_attack_visual.set_point_position(1, local_hit_position)  #(laser_attack_raycast_2d.get_collision_point()-global_position))
	else:
		# No collision = draw full length ray
		laser_attack_visual.set_point_position(1, laser_attack_raycast_2d.target_position)
	
	if laser_affect_player:
		



			
		if laser_attack_raycast_2d.get_collider() != null and laser_attack_raycast_2d.get_collider().is_in_group("player"):
			var player = laser_attack_raycast_2d.get_collider()

			if GlobalScript.playerhasbeenhit == false:
				GlobalScript.playerhasbeenhit = true
				GlobalScript.health -= 3
				player.anim.play("stun_air")
				if player.stunSound:
					player.stunSound.play()

func animation_finished_function(animation_finished:String):
	if animation_finished=="laser_sweep" or animation_finished=="laser_sweep_right":
		transition.emit(self,"idle")
func rogue_animation_finished():
	if animated_sprite_2d.animation=="laser":
		var distance=rogue_riot.distance_x
		if distance<=0:
			main_animation_player.play("laser_sweep")
		elif distance>0:
			main_animation_player.play("laser_sweep_right")
		await get_tree().create_timer(.2).timeout
		laser_attack_visual.visible=true
		#laser_attack_visual.visible=true
		laser_affect_player=true

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
