extends State
@onready var megaman_improved: CharacterBody2D = $"../.."
@onready var player_context_megaman: Node2D = $"../../player_context_megaman"
@onready var animations: AnimatedSprite2D = $"../../animations"
var animation_played_once:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	animations.animation_finished.connect(_animations_finished)

func Enter():
	pass

func Exit():
	pass

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	shoot_and_charge()
		
		#if megaman_improved.is_on_floor():
			##if animation_played_once==false:
				#if megaman_improved.velocity.x==0:
					#animations.play("shoot_idle")
				#animation_played_once=true
	if Input.is_action_just_released("shoot") or (Input.is_action_just_pressed("shoot") and MegamanAndItems.charge_timer<MegamanAndItems.charge_buster_times[1]):
		if megaman_improved.is_on_floor():
			#if animation_played_once==false:
				if megaman_improved.velocity.x==0:
					player_context_megaman.is_attacking=true
					#animations.play("shoot_idle")
					megaman_improved.player_context.request_animation("shoot_idle",100)
				if megaman_improved.velocity.x!=0:
					player_context_megaman.is_attacking=true
					#animations.play("shoot_run")
					megaman_improved.player_context.request_animation("shoot_run",100)
				
		if not megaman_improved.is_on_floor():
			#if animation_played_once==false:
				#if megaman_improved.velocity.x==0:
					player_context_megaman.is_attacking=true
					#animations.play("shoot_in_air")
					megaman_improved.player_context.request_animation("shoot_in_air",100)
	if animations.animation=="shoot_in_air" and megaman_improved.is_on_floor():
			player_context_megaman.is_attacking=false
	MegamanAndItems.charge_effect(animations)
	#GlobalLogger.debug(name,"charge_timer:%s"%MegamanAndItems.charge_timer)
var projectile;
var lemon=preload("res://players/projectiles/lemon.tscn");
var chargeshot_lv1=preload("res://players/projectiles/chargeshot_lv_1.tscn");
var chargeshot_lv2=preload("res://players/projectiles/chargeshot_lv_2.tscn");

func shoot_and_charge():
	if MegamanAndItems.charge_timer == 15:
		$"../../all_sounds/charge".play()
	#if Input.is_action_pressed("shoot"):
		#MegamanAndItems.charge_timer += 1
	if Input.is_action_pressed("shoot"):
		MegamanAndItems.charge_timer+=1
		animation_played_once=false
	#else:
		#MegamanAndItems.charge_timer=0

	elif Input.is_action_just_released("shoot"):
		$"../../all_sounds/charge".stop()
		if MegamanAndItems.charge_timer < MegamanAndItems.charge_buster_times[1]:  #30
			projectile = lemon.instantiate()
			$"../../all_sounds/shoot".play()
		elif MegamanAndItems.charge_timer >= MegamanAndItems.charge_buster_times[1] and MegamanAndItems.charge_timer < MegamanAndItems.charge_buster_times[2]:
			projectile = chargeshot_lv1.instantiate()
			#coolDownTrigger=true
			#$../../buster_cooldown_timer.start()  #start general cooldown on buster
			$"../../all_sounds/halfcharge".play()
		elif MegamanAndItems.charge_timer >= MegamanAndItems.charge_buster_times[2]:
			projectile = chargeshot_lv2.instantiate()
			#coolDownTrigger=true
			#$../../buster_cooldown_timer.start()  #start general cooldown on buster
			$"../../all_sounds/fullcharge".play()
		MegamanAndItems.charge_timer = 0

		#if MegamanAndItems.charge_timer<30:
		if projectile != null:
			get_parent().add_child(projectile)

			if megaman_improved.is_on_floor():
				MegamanAndItems.charge_timer = 0
				if $"../../animations".flip_h == false:
					#lemon_ins=lemon.instantiate()
					#get_parent().add_child(projectile)
					projectile.direction = "left"
					projectile.global_position = $"../../all_proj_spawn_points/ground_left".global_position
				elif $"../../animations".flip_h == true:
					#projectile=lemon.instantiate()
					#get_parent().add_child(projectile)
					projectile.direction = "right"
					projectile.global_position = $"../../all_proj_spawn_points/ground_right".global_position
			elif not megaman_improved.is_on_floor():
				MegamanAndItems.charge_timer = 0
				if $"../../animations".flip_h == false:
					projectile.direction = "left"
					projectile.global_position = $"../../all_proj_spawn_points/air_left".global_position
				elif $"../../animations".flip_h == true:
					projectile.direction = "right"
					projectile.global_position = $"../../all_proj_spawn_points/air_right".global_position
			#elif climb == true:
				#if $../../anim.flip_h == false:
					#projectile.direction = "left"
					#projectile.global_position = $../../all_proj_spawn_points/air_left.global_position
				#elif $../../anim.flip_h == true:
					#projectile.direction = "right"
					#projectile.global_position = $../../all_proj_spawn_points/air_right.global_position

func _animations_finished():
	match animations.animation:
		"shoot_idle","shoot_run","shoot_in_air":
			player_context_megaman.is_attacking=false
			
