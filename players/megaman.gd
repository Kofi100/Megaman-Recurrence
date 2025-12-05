extends CharacterBody2D
class_name Player
static var playerCharacter: Player

##This value keeps the path of the AnimatedSprite2D used for Megaman.
@onready var anim = $anim
##This value keeps the path of the dash node used for Megaman to deterimine his speed.
@onready var dash = $dash
@onready var animation_player = $AnimationPlayer
@onready var animation_player_2 = $AnimationPlayer2

##This is the default speed which can be adjusted by dashing.
@export var SPEED = 0
##This value deterimines how high a person can jump.
@export var JUMP_VELOCITY = -3000  #-340#-4950#orig: -333*3 almost=1000
##This value defines how much gravity is applied by the engine to the player.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var gravity = 900  #1000#3000
@export var dashspeed = 10080  #10000#3000/3;
@export var max_gravity = 25200
var dashduration = 0.3
@export var normalspeed = 4950  #5800 #17500.0=5800/3
var climb = false
var move_an_inch_checker = 0
@export var move_an_inch_speed = 720  #1000
var charge_timer = 0
var jump_play_effect_timer = 0
var is_dead: bool = false
##This boolean checks if a player has been stunned or not
##and triggers the stun effect
var is_stunned: bool = false#stun_effect :old name 
var trans_left = false
var trans_right = false
var trans_up = false
var trans_down = false

var lemon = preload("res://players/projectiles/lemon.tscn")
var lemon_ins
var chargeshot_lv1 = preload("res://players/projectiles/chargeshot_lv_1.tscn")
var chargeshot_lv1_ins
var chargeshot_lv2 = preload("res://players/projectiles/chargeshot_lv_2.tscn")
var chargeshot_lv2_ins
var rush_coil = preload("res://players/weapons/rush_coil.tscn")

var rush_coil_instance
var direction: float = 0
var lastDirectionCase: float = 0
var stop: bool = false
var timer = 0
#var weapon_number: int = 0
var max_weapon_number = 11
var screen_transition_finished: bool = false
var restart_scene: bool = false
var conveyor_push = 3000
var on_conveyor: bool = false
var player_ready: bool = false
var in_teleporter = false
var key_dictionary: Array
var JBufferActive: bool = false
var jumpAvble: bool = true
#var jump_buffer_timer
@onready var jump_buffer_timer: Timer = $all_timers/jump_buffer_timer

var coyoteJumpTime
@onready var trigger_leave_timer = $all_timers/trigger_leave_timer
#timer deterimining how long stays on screen before despawning
@onready var leave_timer = $all_timers/leave_timer
@onready var buster_cooldown_timer: Timer = $all_timers/buster_cooldown_timer
@onready var jump_timer: Timer = $all_timers/jump_Timer

var onIce: bool = false
var inWater:bool=false
var justLeftIce: bool = false
@onready var stunSound: SFX = $all_sounds/stun
var deltaAlt
var hasStunEffectApplied:bool=false
var playLeaveBGM:bool=true
var player_transition_direction_x:String
var player_transition_direction_y:String
@export var allowed_transition_movement:Dictionary={
	"left":true,"right":true,"up":true,"down":true
}
var transition_velocity:Vector2

func _ready():
	playerCharacter = self
	GlobalSignalBus.connect("player_knockback", _on_knockback_signal)
	#health
	#key_dictionary.resize(9)
	GlobalScript.lemons_on_screen_no = 0
	GlobalScript.playerhasbeenhit = false
	GlobalScript.trigger_boss = false
	#reloads Color Palette to keep it updated
	MegamanAndItems.reload_palette()

	$anim.material.set_shader_parameter("outlinecolor", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
	$anim.material.set_shader_parameter("bodycolori", (Vector4(136.0, 232.0, 255.0, 255.0)) / 255)
	$anim.material.set_shader_parameter("bodycolorii", (Vector4(0.0, 98.0, 247.0, 255.0)) / 255)

	player_ready = false
	anim.play("idle")
	anim.visible = false
#	if restart_scene==true:
#		get_tree().reload_current_scene()
#		restart_scene=false
#region Timers Section
	GlobalScreenTransitionTimer.stop()
#having suspicisions that this coud be the cause of the game's eventual slowdowns 
#at 20mins+ gameplay time
	##jump_buffer_timer = Timer.new()
	#coyoteJumpTime = Timer.new()
	##jump_buffer_timer.wait_time = .1
	#coyoteJumpTime.wait_time = 0.05
	##get_parent().add_child.call_deferred(jump_buffer_timer)
	#get_parent().add_child.call_deferred(coyoteJumpTime)
#endregion

	if GlobalScript.restarted_level == false:
		#GlobalScript.score = 0
		GlobalScript.reset_level_timer()
		GlobalScript.start_level_timer()
		#GlobalScript.save_savepoint_data()
	elif GlobalScript.restarted_level == true:
		GlobalScript.start_level_timer()
		GlobalScript.load_savepoint_data()
		global_position.x = GlobalScript.playerposx
		global_position.y = GlobalScript.playerposy
	MegamanAndItems.charge_timer = 0
	GlobalScript.weapon_number = 0
	#MegamanAndItems.weapon1energy = 27
	#MegamanAndItems.weapon2energy = 27
	#MegamanAndItems.weapon3energy = 27
	for keyValue in MegamanAndItems.weaponEnergy:#using keyValue since weaponEnergy is a dictionary.
		MegamanAndItems.weaponEnergy[keyValue]=27
	#MegamanAndItems.weaponEnergy.fill()
	GlobalScript.health = GlobalScript.max_health  #health setting
	$weapon_display.visible = false
	$stun_effects.visible=false
	$player_camera.position_smoothing_enabled = false
	$hitbox/CollisionShape2D.disabled = true
	GlobalScript.boss=null
	#setting some extra
	alarmSignalInstanceArray.fill(null)

var onrush = false
var disable_input = false
var switch_state = 0
var door_transition = false


func debug_print_custom(name_of_node, var_name_to_be_displayed, variable_name):
	print(name_of_node, ":", str(var_name_to_be_displayed), ": ", variable_name)


func leaving(delta):
	if leave_timer.time_left<leave_timer.wait_time/2:
		stop = true
	#for i in get_tree().current_scene.get_children(true):
		#if i.is_class("AudioStreamPlayer") or i.is_class("AudioStreamPlayer2D"):
			#i.stop()
	if leave_timer.time_left <= 0:
		#velocity.y = 0
		pass
		if anim.animation != "spawn":
			anim.play("spawn")
		if anim.animation == "spawn" and anim.frame == 2:
			velocity.y = -15000 * delta

			$CollisionShape2D.disabled = true
			$hitbox/CollisionShape2D.disabled = true
			$player_constants_checker_area2d/CollisionShape2D.disabled = true

	else:
		velocity.y += gravity * delta
		if not is_on_floor():
			anim.play("jump")
		else:
			anim.play("idle")
	move_and_slide()


var leave_bool = false
var has_played_victory_sound: bool = false
var WeaponCheckDirection:int=0
func checkWeaponAvalability():
	
	if MegamanAndItems.weaponNumberEnabled.has(GlobalScript.weapon_number):
		if MegamanAndItems.weaponNumberEnabled[GlobalScript.weapon_number]==true:
			pass
		elif MegamanAndItems.weaponNumberEnabled[GlobalScript.weapon_number]==false:
			if WeaponCheckDirection==-1:
				GlobalScript.weapon_number-=1
			if WeaponCheckDirection==1:
				GlobalScript.weapon_number+=1
	#print(GlobalScript.weapon_number)
	#print(MegamanAndItems.weaponNumberEnabled)
var enabledLeavingCode:bool=false
func checkIfStuck():
	if $checkIfStuckNodes/RayCast2D.is_colliding() or $checkIfStuckNodes/RayCast2D2.is_colliding():
		GlobalScript.health=0
func moveWhenStoppedOnScreenTransition():
	if not GlobalScreenTransitionTimer.is_stopped():
		if velocity.x==0:
			pass
func _physics_process(delta):
#region reverse Gravity
	#code for reverse gravity
	#gravity=-980
	#self.scale.y=-1
#endregion
	#if $RayCastLeft.get_collider() != null:
	#print($RayCastLeft.get_collider().is_in_group("iceTiles"))
	#print("onIce:", onIce)
	#print("velocity,speed:", SPEED)
	GlobalScript.player = self
	deltaAlt=delta
	if playLeaveBGM==false:
			leave_timer.wait_time=.2
	#print($leave_timer.wait_time)
	if leave_bool == true:
		if has_played_victory_sound == false and playLeaveBGM==true:
			has_played_victory_sound = true
			$all_sounds/level_cleared.play()

		#velocity.x = 0
		$hitbox/CollisionShape2D.disabled = true
		if  enabledLeavingCode:
			leaving(delta)
			
	if $all_timers/reset_cam_entry.time_left > 0:
		$player_constants_checker_area2d/CollisionShape2D.disabled = true
	elif $all_timers/reset_cam_entry.time_left <= 0:
		$player_constants_checker_area2d/CollisionShape2D.disabled = false
	#print($player_constants_checker_area2d/CollisionShape2D.disabled)
#region Debug Zone
	##debug
	#print(name,':GScript:lemon_no:',GlobalScript.lemons_on_screen_no)
	#debug_print_custom(name,"GScript:lemon_no",GlobalScript.lemons_on_screen_no)
	#debug_print_custom(name,"cooldown_timer:time_left",$buster_cooldown_timer.time_left)
	#debug_print_custom(name,'stop,stun_effect,disable_input:',[stop,stun_effect,disable_input])

	$charge_timer.text = str(MegamanAndItems.charge_timer)
	$speed.text = str(velocity * Vector2(pow(delta, 1), pow(delta, 1)))  #*delta
	#print(JUMP_VELOCITY)
	#pow(delta,2)
	#print(ProjectSettings.get_setting("application/run/max_fps",0))
	##
#endregion
	#Limit gravity
	velocity.y = clampf(velocity.y, -420, 420)  #since velocity is actually a value *delta
	#velocity.y = clampf(velocity.y, -25200 * delta, 25200 * delta) 
	#if velocity.y>25200*delta:
	#velocity.y=25200*delta

	if not player_ready:
		GlobalScreenTransitionTimer.stop()
	#if not GlobalScript.buster_rapid_shot:
	if GlobalScript.lemons_on_screen_no >= 3 and buster_cooldown_timer.time_left <= 0:
		buster_cooldown_timer.start()
	#else:
		#GlobalScript.lemons_on_screen_no=0
	#conveyor_push=30000
	if door_transition:
		velocity.x = 4950 * delta
		velocity.y = 0
		move_and_slide()
		stop = true
	if GlobalScreenTransitionTimer.time_left > 0:
		$player_camera.position_smoothing_enabled = true
		stop = true
		screen_transition_finished = false
		#match camera_transition_direction:
			#"HORIZONTAL":
				#if velocity.y>0:
					#
		#match player_transition_direction_x:
			#"NONE":
				#pass
			#"LEFT":
				#trans_left = true
			#"RIGHT":
				#trans_right=true
		#match player_transition_direction_y:
			#"NONE":
				#pass
			#"UP":
				#trans_up = true
			#"DOWN":
				#trans_down=true
	##on-standby code
		#transitions up and down only happen when on a ladder
		#if player_transition_direction_y=="NONE" or player_transition_direction_y=="":
			#if velocity.y > 0 and climb:
				#trans_down = true
			#if velocity.y < 0 and climb:
				#trans_up = true
		#else:
			#match player_transition_direction_y:
				#"UP":
					#trans_up = true
				#"DOWN":
					#trans_down=true
		#if player_transition_direction_y=="NONE" or player_transition_direction_y=="":
			#if velocity.x > 0:
				#trans_right = true
			#if velocity.x < 0:
				#trans_left = true
	##
		#print(name,":",[trans_left,trans_right])
		if velocity.x<0:
			if allowed_transition_movement.left:
				#if velocity.x<=0:
					trans_left=true
				
		if velocity.x>=0:
			if allowed_transition_movement.right:
				#if velocity.x>=0:
					trans_right=true
		if velocity.y<0:
			if allowed_transition_movement.up==true or climb:
				trans_up=true
		if velocity.y>=0:
			if allowed_transition_movement.down==true or climb:
				trans_down=true
			


	elif GlobalScreenTransitionTimer.time_left <= 0:
		if not screen_transition_finished:
			$player_camera.position_smoothing_enabled = false
			stop = false
			trans_down = false
			trans_up = false
			trans_left = false
			trans_right = false
			transition_velocity=Vector2.ZERO

			screen_transition_finished = true

	if Input.is_action_just_pressed("die_debug"):
		GlobalScript.health = 0

	GlobalScript.playerposx = global_position.x
	GlobalScript.playerposy = global_position.y

	if dash.is_dashing() and is_on_floor():
		SPEED = dashspeed
	else:
		SPEED = normalspeed
	#elif on_conveyor:
	#SPEED = normalspeed - conveyor_push
	# Add the gravity.
	if is_on_floor():
		if jump_play_effect_timer < 5:
			jump_play_effect_timer += 1
			if jump_play_effect_timer == 1:
				$all_sounds/mm10land.play()
				pass
				#animation_player_2.play('screen_shake') #for testing screen shake later
	elif not is_on_floor():
		jump_play_effect_timer = 0
	#var tween=create_tween()
	
	if trans_right:
		transition_velocity.x = 1000
		#position.x+=10*delta
		#move_and_slide()

	if trans_down:
		transition_velocity.y = 1000
		#move_and_slide()
		#tween.stop()
	if trans_up:
		transition_velocity.y = -1000
		#velocity = Vector2(0, -1000) * delta
		#move_and_slide()
	if trans_left:
		transition_velocity.x=-1000
		#velocity = Vector2(-1000, 0) * delta
		#move_and_slide()
	
	if transition_velocity!=Vector2.ZERO:
		velocity=transition_velocity*delta
		move_and_slide()

	if GlobalScript.weapon_number < 0:
		GlobalScript.weapon_number = max_weapon_number
	elif GlobalScript.weapon_number > max_weapon_number:
		GlobalScript.weapon_number = 0
	delete_weapons()
	#print(weapon_number)
	#print(move_an_inch_checker)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if GlobalScript.weapon_number!=0:
		MegamanAndItems.change_palette($anim)
	else:
		MegamanAndItems.charge_effect(anim)
	if Input.is_action_just_released("shoot"):
		#GlobalScript.playerhasbeenhit
		if (anim.animation=="stun_air" or GlobalScreenTransitionTimer.is_stopped()==false):
			MegamanAndItems.charge_timer=0
			#print("Release buster while stunned or transitioning :on")
			Logger.debug(name,"Release buster while stunned or transitioning :on")
	#if 
	if MegamanAndItems.charge_timer==0:
		if $all_sounds/charge.playing:
			$all_sounds/charge.stop()
	
	if !is_dead:
		
		#if $all_sounds/charge.get_playback_position()>2.04:
		##print("seek")
		#$all_sounds/charge.seek(1.90)
		if MegamanAndItems.weaponNumberEnabled[GlobalScript.weapon_number]:
			$weapon_display.frame = GlobalScript.weapon_number

		if leave_bool == false and player_ready==true:
			if GlobalScript.playerhasbeenhit:
				$hitbox/CollisionShape2D.disabled = true
			elif not GlobalScript.playerhasbeenhit:
				$hitbox/CollisionShape2D.disabled = false
		change_collisions()
		if Input.is_action_just_pressed("switch_weapon_left"):
			GlobalScript.weapon_number -= 1
			WeaponCheckDirection=-1
			#checkWeaponAavability(-1)
			$weapon_display.visible = true
			$weapon_display/display_timer.start()
		elif Input.is_action_just_pressed("switch_weapon_right"):
			$weapon_display.visible = true
			GlobalScript.weapon_number += 1
			WeaponCheckDirection=1
			#checkWeaponAavability(1)
			$weapon_display/display_timer.start()
		checkWeaponAvalability()
		#placing it here to work even in Screen Transitions and Flinches
		activeUseOfWeapons()
		stun(delta)
	
		if GlobalScript.playerhasbeenhit and !is_dead:
			if $all_timers/hit_blink_timer.is_stopped():
				$all_timers/hit_blink_timer.start()
		else:
			if not $all_timers/hit_blink_timer.is_stopped():
				$all_timers/hit_blink_timer.stop()
				anim.visible=true
		if player_ready and stop == false:
			checkIfStuck()
			#if jump_buffer_timer:
			#
			#print("timer creating...")
			# Handle Jump.
			#if jump_buffer_timer.tree_exiting():
			#print("jumpBuffer getting destroyed")
			#if tree_exiting()
			if Input.is_action_just_pressed("jump") and jump_buffer_timer.time_left <= 0:  # is_on_floor():#and !is_on_floor(): #and is_on_floor():# and is_on_floor():
				jump_buffer_timer.start()
				anim.play("jump")
				#velocity.y = JUMP_VELOCITY*delta
			#print(jump_buffer_timer.time_left)

#region Coyote Jumping(not active)
			#if is_on_floor():jumpAvble=true
			#if !is_on_floor() and velocity.y>0 and velocity.y<=15 and coyoteJumpTime.time_left<=0 and jumpAvble==true:
			#coyoteJumpTime.start()
			#jumpAvble=false
			#print("coyoteJmpTime")
			#if Input.is_action_just_pressed("jump") and coyoteJumpTime.time_left>0:
			#velocity.y = JUMP_VELOCITY
			#coyoteJumpTime.stop()
#endregion

			#print("Mega:velocity.y",velocity.y)
			#print("Mega:velocity*delta=i think,pixel/frame/second",velocity*Vector2(delta,delta))
			if jump_buffer_timer.time_left > 0 and is_on_floor():
				#print(name+":"+Jump Buffer Time Left:"+jump_buffer_timer.time_left)
				velocity.y = JUMP_VELOCITY #* delta
				jump_buffer_timer.stop()

			if Input.is_action_just_released("jump") and velocity.y < 0:
				velocity.y = 0
			#if Input.is_action_pressed("dash") and is_on_floor():#anim.animation=="dash":
				#anim.offset.y=3
			if onrush == false:
				
				if GlobalScript.weapon_number == 0:
					if buster_cooldown_timer.time_left <= 0:
						shoot_and_charge()
						
				else:
					#MegamanAndItems.change_palette($anim)
					create_weapons()
				
				if climb == false:
					if near_ladder:
						if Input.is_action_pressed("move_up"):
							climb = true

					if not is_on_floor():
						velocity.y += gravity * delta
					if inWater:
						gravity=500
						anim.speed_scale=0.8
					else:
						gravity=900
						anim.speed_scale=1.0
					apply_movement_x(delta)
					# Apply knockback movement
					if knockback_velocity != Vector2.ZERO:
						
						stun(delta)
						velocity += knockback_velocity * delta
						knockback_decay(delta)
					play_animations()
					offsetAnimationFunction()
					dash_function(delta)

				elif climb == true:
					if Input.is_action_pressed("jump"):
						climb = false

					if ladder_collider != null:
						velocity.x = 0
						global_position.x = ladder_collider.global_position.x
					play_animation_ladder()
					#these codes are for playing animations
					direction = Input.get_axis("move_up", "move_down")
					if direction and anim.animation != "shoot_on_ladder" and not disable_input:
						velocity.y = direction * 3500 * delta
					else:
						velocity.y = 0
				move_and_slide()
				if GlobalScript.health <= 0:
					$all_timers/restart_timer.start(3.5)
					is_dead = true
					#max_lives=9 stands for infinite lives
					if GlobalScript.max_lives<9:
						GlobalScript.lives = GlobalScript.lives - 1
					var explosion_scene = preload("res://miscellenaous/effects/explosion_scene.tscn")
					var explosion_scene_instance_or_node = explosion_scene.instantiate()
					get_parent().add_child(explosion_scene_instance_or_node)
					explosion_scene_instance_or_node.global_position = global_position
					$all_sounds/dead.play()
			elif onrush == true:
				velocity.x = 0
				MegamanAndItems.charge_timer = clampi(MegamanAndItems.charge_timer, 0, 5)
				if buster_cooldown_timer.time_left <= 0:
					shoot_and_charge()
				MegamanAndItems.charge_effect(anim)
				if $anim.animation == "shoot_idle":
					if $anim.flip_h == false:
						$anim.offset.x = -6
					elif $anim.flip_h == true:
						$anim.offset.x = 6
				else:
					$anim.offset.x = 0
					if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
						if anim.animation != "shoot_idle" and anim.animation != "whistle_idle":  #or anim.animation!="stun"
							$anim.play("idle")
					elif Input.is_action_just_released("shoot"):
						$anim.play("shoot_idle")
				if Input.is_action_pressed("move_left"):
					anim.flip_h = false
				elif Input.is_action_pressed("move_right"):
					anim.flip_h = true
				if Input.is_action_just_pressed("jump"):
					onrush = false
#region debug whistle code by reposition it, i guess would work on it soon
		#if velocity.x==0 and $whistle_idle_trigger_timer.time_left<=0 and not Input.is_action_pressed("shoot") and not Input.is_action_pressed("jump")and MegamanAndItems.charge_timer<30:
		#$whistle_idle_trigger_timer.start()
		#print("megaman: whistle_timer cdn fulfilled")
#endregion
		elif stop == true:
			velocity = Vector2.ZERO
	elif is_dead:
		#stun_air plays via hud which receives the change in the health value first
		#anim.play("stun_air")
		GlobalScript.restarted_level = true
		GlobalScript.pause_level_timer()
		$all_timers/hit_blink_timer.stop()
		anim.visible = false
		$hitbox/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		#await get_tree().create_timer(.2).timeout
		


var dead_effect_timer = 0
var stun_timer = 0
@export var stun_speed = 1200

func apply_movement_x(delta):
	stun_speed=25
	direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		lastDirectionCase = direction
	if direction and not disable_input:
		move_an_inch_checker += 1
		if not is_on_floor():
			velocity.x = direction * SPEED * delta
		else:
			if move_an_inch_checker < 10:
				velocity.x = direction * move_an_inch_speed * delta  #1000 *delta
			#elif on_conveyor:
				#velocity.x = direction * (SPEED + conveyor_push) * delta
			elif onIce:
				if direction == -1:
					velocity.x = direction * (SPEED + 500) * delta
					
				elif direction == 1:
					velocity.x = direction * (SPEED + 500) * delta
			else:
				velocity.x = direction * (SPEED) * delta

	else:
		move_an_inch_checker = 0
		if onIce:
			if lastDirectionCase < 0:
				velocity.x = -abs(velocity.x) + 200 * delta
				if velocity.x >= 0:
					velocity.x = 0
			elif lastDirectionCase > 0:
				velocity.x = abs(velocity.x) - 200 * delta
				if velocity.x <= 0:
					velocity.x = 0
		else: 
			velocity.x = move_toward(velocity.x, 0, SPEED)

func offsetAnimationFunction():
	if (
		#anim.animation != "shoot_idle"
		anim.animation != "dash"
		#and anim.animation != "shoot_run"
		and anim.animation != "jump"
		and anim.animation != "shoot_in_air"
		and anim.animation != "run"
		and anim.animation != "stun"
	):
		$anim.offset.x = 0
		$anim.offset.y = 0
	else:
		match anim.animation:
			"dash":
				$anim.offset.y = 3
			"jump":
				if $anim.flip_h == false:
					$anim.offset.x = -1
				elif $anim.flip_h == true:
					$anim.offset.x = 1
			"shoot_in_air":
				if $anim.flip_h == false:
					$anim.offset.x = -3
				elif $anim.flip_h == true:
					$anim.offset.x = 3
			"run":
				$anim.offset.y = 0
			#"stun":
				#$anim.offset.y=3
var stun_effect_created:bool=false
var stun_effect:Node2D

#func stun(_delta):
	#if anim.animation == "stun_air" and GlobalScript.health > 0:
		##if not $stun_effects/dusts/dust.is_playing() and stop==false:
			##$stun_effects/dusts/dust.play("dust")
			##$stun_effects/dusts/dust2.play("dust")
			##$stun_effects/dusts/dust3.play("dust")
		#
		#if not stun_effect_created:
			#stun_effect=preload("res://miscellenaous/effects/stun_effect.tscn").instantiate()
			#get_tree().current_scene.add_child(stun_effect)
			#stun_effect.z_index=-1
			#stun_effect.global_position=global_position
			#
			#
			#for dust_position in $stun_effects_positions.get_children():
				#var dust=preload("res://miscellenaous/effects/stun_dust.tscn").instantiate()
				#get_tree().current_scene.add_child(dust)
				#dust.z_index=-1
				#dust.global_position=dust_position.global_position
			#
			#stun_effect_created=true
		#disable_input = true
		#is_stunned = true
		#stop = true
		##$stun_effects.visible=true#/MegamanStunEffects
		##$stun_effects/dusts.visible=true
#
		##if anim.flip_h == false:
			##velocity = Vector2(stun_speed, 0) * delta
		##elif anim.flip_h == true:
			##velocity = Vector2(-stun_speed, 0) * delta
		#velocity.x = knockback_velocity.x +(stun_speed if anim.flip_h==false else -stun_speed)
		##velocity.x = knockback_velocity.x + (is_stunned ? stun_speed * (anim.flip_h ? -1 : 1) : 0)
		##if velocity.y<0:
			##velocity.y=0
		#if not is_on_floor():
			#velocity.y+=gravity*_delta 
		#else:
			#velocity.y=0
		##velocity.y = knockback_velocity.y + (80 if !is_on_floor() else 0)
#
		##if not is_on_floor():
			##velocity.y=80#*delta#WIP 
		#move_and_slide()
	#elif GlobalScript.health <= 0:
		#stop = false
	#if anim.animation != "stun_air" or GlobalScript.health <=0:
		##$stun_effects.visible=false
		#stun_effect_created=false
		#if stun_effect:
			#stun_effect.queue_free()
		#

func stun(_delta):
	if anim.animation == "stun_air" and GlobalScript.health > 0:
		#if not $stun_effects/dusts/dust.is_playing() and stop==false:
			#$stun_effects/dusts/dust.play("dust")
			#$stun_effects/dusts/dust2.play("dust")
			#$stun_effects/dusts/dust3.play("dust")
		$stun_effects.visible=true
		if not stun_effect_created:
			#stun_effect=preload("res://miscellenaous/effects/stun_effect.tscn").instantiate()
			#get_tree().current_scene.add_child(stun_effect)
			#stun_effect.z_index=-1
			#stun_effect.global_position=global_position
			
			
			for dust_position in $stun_effects_positions.get_children():
				var dust=preload("res://miscellenaous/effects/stun_dust.tscn").instantiate()
				get_tree().current_scene.add_child(dust)
				#dust.z_index=-1
				dust.global_position=dust_position.global_position
			
			stun_effect_created=true
		disable_input = true
		is_stunned = true
		stop = true
		#$stun_effects.visible=true#/MegamanStunEffects
		#$stun_effects/dusts.visible=true

		#if anim.flip_h == false:
			#velocity = Vector2(stun_speed, 0) * delta
		#elif anim.flip_h == true:
			#velocity = Vector2(-stun_speed, 0) * delta
		velocity.x = knockback_velocity.x +(stun_speed if anim.flip_h==false else -stun_speed)
		#velocity.x = knockback_velocity.x + (is_stunned ? stun_speed * (anim.flip_h ? -1 : 1) : 0)
		if velocity.y<0:
			velocity.y=0
		if not is_on_floor():
			velocity.y+=gravity*_delta 
		#velocity.y = knockback_velocity.y + (80 if !is_on_floor() else 0)

		#if not is_on_floor():
			#velocity.y=80#*delta#WIP 
		move_and_slide()
	elif GlobalScript.health <= 0:
		stop = false
	if anim.animation != "stun_air": #or GlobalScript.health <=0:
		$stun_effects.visible=false
		stun_effect_created=false
		if stun_effect:
			stun_effect.queue_free()
		
var knockback_velocity = Vector2.ZERO
var knockback_friction = 300
#var is_stunned = false
var stun_duration = 0.5

func apply_knockback(direction_apply: int, force: float, vertical_force: float = 0):
	# direction: -1 for left, 1 for right
	knockback_velocity.x = force * direction_apply
	knockback_velocity.y = vertical_force
	print(name,": apply_knockback active")


func _on_knockback_signal(direction_apply, force, vertical_force):
	apply_knockback(direction_apply, force, vertical_force)
	anim.play("stun_air")

func stun_temporarily(ground_stun_time:float=0.5):
	stop=true
	disable_input=true
	anim.play("stun")
	$anim.offset.y=2
	await get_tree().create_timer(ground_stun_time).timeout
	$anim.offset.y=0
	stop=false
	disable_input=false
	#anim.play("stun")
	
var frameNo = 0
func knockback_decay(delta):
	# Knockback friction
	if knockback_velocity.x != 0:
		var friction = knockback_friction * delta
		if abs(knockback_velocity.x) <= friction:
			knockback_velocity.x = 0
		else:
			knockback_velocity.x -= sign(knockback_velocity.x) * friction
	if knockback_velocity.y != 0:
		# Optional: reduce vertical knockback gradually
		knockback_velocity.y = move_toward(knockback_velocity.y, 0, knockback_friction * delta)

func play_animations():
	if direction == -1:
		$anim.flip_h = false
	elif direction == 1:
		$anim.flip_h = true
	if $anim.animation == "run":
		frameNo = $anim.frame
	#print("FrameNo:", frameNo)
	
	if is_on_floor():
		if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
			if anim.animation != "stun_air":
				if move_an_inch_checker >= 10:
					if not is_dashing and $all_timers/check_dash_released_timer.is_stopped():
						if anim.animation != "shoot_run" :
							anim.play("run")
						#prevents dash from playing when run is supposed to 
						#after the dash timer runs out
						elif  $dash/Timer.is_stopped() and anim.animation == "dash":
							if $all_timers/check_dash_released_timer.is_stopped():
								anim.play("run")
				
				elif move_an_inch_checker < 10:
					#make sure that shoot_idle animation plays when player
					#releases shoot button while moving an inch
					if velocity.x != 0 and anim.animation!="shoot_idle":
						$anim.play("move_by_inch")
					elif velocity.x == 0:
						#soln1
						if $anim.animation != "shoot_idle" and anim.animation != "whistle_idle" and anim.animation!="climb_transition":
							$anim.play("idle")
							#$jump_Timer.start()
							#soln2
						#if $anim.animation != "shoot_idle" and anim.animation != "idle" and $jump_Timer.is_stopped() == true:
						##$anim.play("idle")
						#$jump_Timer.start()
						#MegamanAndItems.charge_timer=0

		elif Input.is_action_just_released("shoot") and buster_cooldown_timer.time_left <= 0:
			if anim.animation != "stun_air":
				if move_an_inch_checker >= 10:
					if anim.animation != "shoot_run":
						anim.play("shoot_run")
						$anim.frame = frameNo
				if move_an_inch_checker < 10:
					if anim.animation != "shoot_idle": #and anim.animation!="move_by_inch":
						anim.play("shoot_idle")

	elif not is_on_floor():
		if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
			if $anim.animation != "shoot_in_air" and anim.animation != "stun_air" and anim.animation!="climb_transition":
				$anim.play("jump")
		elif Input.is_action_just_released("shoot") and buster_cooldown_timer.time_left <= 0:
			if anim.animation != "shoot_in_air" and anim.animation != "stun_air":
				$anim.play("shoot_in_air")


var projectile
var coolDownTrigger = false


func shoot_and_charge():
	if MegamanAndItems.charge_timer == 15:
		$all_sounds/charge.play()
	if Input.is_action_pressed("shoot"):
		MegamanAndItems.charge_timer += 1

	elif Input.is_action_just_released("shoot"):
		$all_sounds/charge.stop()
		if MegamanAndItems.charge_timer < MegamanAndItems.charge_buster_times[1]:  #30
			projectile = lemon.instantiate()
			$all_sounds/shoot.play()
		elif MegamanAndItems.charge_timer >= MegamanAndItems.charge_buster_times[1] and MegamanAndItems.charge_timer < MegamanAndItems.charge_buster_times[2]:
			projectile = chargeshot_lv1.instantiate()
			#coolDownTrigger=true
			#$buster_cooldown_timer.start()  #start general cooldown on buster
			$all_sounds/halfcharge.play()
		elif MegamanAndItems.charge_timer >= MegamanAndItems.charge_buster_times[2]:
			projectile = chargeshot_lv2.instantiate()
			#coolDownTrigger=true
			#$buster_cooldown_timer.start()  #start general cooldown on buster
			$all_sounds/fullcharge.play()
		MegamanAndItems.charge_timer = 0

		#if MegamanAndItems.charge_timer<30:
		if projectile != null:
			get_parent().add_child(projectile)

			if is_on_floor():
				MegamanAndItems.charge_timer = 0
				if $anim.flip_h == false:
					#lemon_ins=lemon.instantiate()
					#get_parent().add_child(projectile)
					projectile.direction = "left"
					projectile.global_position = $all_proj_spawn_points/ground_left.global_position
				elif $anim.flip_h == true:
					#projectile=lemon.instantiate()
					#get_parent().add_child(projectile)
					projectile.direction = "right"
					projectile.global_position = $all_proj_spawn_points/ground_right.global_position
			elif not is_on_floor():
				MegamanAndItems.charge_timer = 0
				if $anim.flip_h == false:
					projectile.direction = "left"
					projectile.global_position = $all_proj_spawn_points/air_left.global_position
				elif $anim.flip_h == true:
					projectile.direction = "right"
					projectile.global_position = $all_proj_spawn_points/air_right.global_position
			elif climb == true:
				if $anim.flip_h == false:
					projectile.direction = "left"
					projectile.global_position = $all_proj_spawn_points/air_left.global_position
				elif $anim.flip_h == true:
					projectile.direction = "right"
					projectile.global_position = $all_proj_spawn_points/air_right.global_position


var switch_to = 0


func shoot_and_charge_ladder():
	pass
	if Input.is_action_pressed("shoot"):
		if MegamanAndItems.charge_timer == 1:
			$all_sounds/charge.play()
		MegamanAndItems.charge_timer += 1


func play_animation_ladder():
	if (not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot")) and not Input.is_action_just_released("shoot"):
		if anim.animation != "shoot_on_ladder":
			if was_leaving == false:
				#if anim.animation!="shoot_on_ladder":
				if Input.is_action_pressed("move_up"):
					$anim.play("climb")

				elif Input.is_action_pressed("move_down"):
					
					$anim.play_backwards("climb")
			#		if $change_climb_detector/CollisionShape2D
			elif was_leaving == true and velocity.y<0:
				#print(name,": Is about to leave ladder")
				$anim.play("climb_transition")
	elif Input.is_action_just_released("shoot"):
		if anim.animation != "shoot_on_ladder":
			anim.play("shoot_on_ladder")
			
			if Input.is_action_pressed("move_left"):
				anim.flip_h = false
			elif Input.is_action_pressed("move_right"):
				anim.flip_h = true

var is_dashing:bool=false
func dash_function(delta):
	#if anim.animation=="dash":
		#anim.offset.y=3
	if is_on_floor():
		if Input.is_action_just_pressed("dash") and $dash/Timer.time_left <= 0:
			dash.start_dash(.5)
			anim.offset.y=3
			is_dashing=true
			var dash_effect = preload("res://players/effects/dash_effect.tscn")
			var dash_effect_instance = dash_effect.instantiate()
			if anim.flip_h == false:
				dash_effect_instance.global_position = $dash_positions/left.global_position
				get_parent().add_child(dash_effect_instance)
				velocity.x = -10000 * delta
				move_and_slide()
			elif anim.flip_h == true:
				dash_effect_instance.global_position = $dash_positions/right.global_position
				get_parent().add_child(dash_effect_instance)
				velocity.x = 10000 * delta
				move_and_slide()
		#if $dash/Timer.time_left()
		#if :
		if Input.is_action_pressed("dash") and $dash/Timer.time_left > 0:
			anim.play("dash")
			#anim.frame=
			if anim.flip_h==false:
				velocity.x=-dashspeed*delta
			elif anim.flip_h==true:
				velocity.x=dashspeed*delta
			#Offset for Dash animation lies here.
			
			#elif $dash/Timer.time_left<=0:
			#velocity.x=0
			#anim.play("idle")
	if Input.is_action_just_released("dash"):
		#if $check_dash_released_timer.is_stopped(): 
		$all_timers/check_dash_released_timer.start()
		$dash/Timer.stop()
		
	#if not is_on_floor() and not $dash/Timer.is_stopped():
		#$check_dash_released_timer.start()
		#$dash/Timer.stop()

	if $dash/Timer.is_stopped():
		is_dashing=false
		
	#$dash/Timer.wait_time=3


func chargeeffect():
	if MegamanAndItems.charge_timer == 0:
		$anim.material.set_shader_parameter("outlinecolor", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
		$anim.material.set_shader_parameter("bodycolori", (Vector4(136.0, 232.0, 255.0, 255.0)) / 255)
		$anim.material.set_shader_parameter("bodycolorii", (Vector4(0.0, 98.0, 247.0, 255.0)) / 255)
	elif MegamanAndItems.charge_timer > 0 and MegamanAndItems.charge_timer < 30:
		if MegamanAndItems.charge_timer % 10 == 1:
			#print('mega chargeeffect:active1')
			$anim.material.set_shader_parameter("outlinecolor", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
		elif MegamanAndItems.charge_timer % 10 == 5:
			#print('mega chargeeffect:active1:2')
			$anim.material.set_shader_parameter("outlinecolor", (Vector4(135.0, 0.0, 142.0, 255.0)) / 255)
	elif MegamanAndItems.charge_timer >= 30 and MegamanAndItems.charge_timer < 75:
		if MegamanAndItems.charge_timer % 10 == 1:
			$anim.material.set_shader_parameter("outlinecolor", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
		elif MegamanAndItems.charge_timer % 10 == 5:
			$anim.material.set_shader_parameter("outlinecolor", (Vector4(135.0, 0.0, 142.0, 255.0)) / 255)
	elif MegamanAndItems.charge_timer >= 75:
		#$animated_sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		if MegamanAndItems.charge_timer % 10 == 1:
			$anim.material.set_shader_parameter("outlinecolor", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
			$anim.material.set_shader_parameter("bodycolori", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
			$anim.material.set_shader_parameter("bodycolorii", (Vector4(0.0, 98.0, 247.0, 255.0)) / 255)
		elif MegamanAndItems.charge_timer % 10 == 5:
			$anim.material.set_shader_parameter("bodycolori", (Vector4(136.0, 232.0, 255.0, 255.0)) / 255)
			$anim.material.set_shader_parameter("bodycolorii", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
			$anim.material.set_shader_parameter("outlinecolor", (Vector4(0.0, 98.0, 247.0, 255.0)) / 255)


var rush_jet = preload("res://players/weapons/rush_jet.tscn")
var rush_jet_instance
var rCoilNo = 0
var useBuster_WhenRCoil:bool=false
var alarmSignal=preload("res://players/weapons/alarm_man_weapon_ring.tscn");
var alarmSignal2=preload("res://players/weapons/alarm_man_weapon_ring.tscn")
var alarmSignalInstance;var alarmSignalInstance2;
var alarmSignalInstanceArray=[null,null,null,null,null,null]#:Array=Array[6]
var alarmMain
var satellite_Weapon=preload("res://players/weapons/satellite_man_weapon_satellite.tscn")
var satellite_SatelliteMini;
func create_weapons():
	#print("alarmSignalInstanceArray[5]:",alarmSignalInstanceArray[5])
	MegamanAndItems.charge_timer = 0
	if Input.is_action_just_pressed("shoot"):
		#deductWeaponEnergy()
		match GlobalScript.weapon_number:
			1:
				if alarmMain==null:
					if WeaponEnergyGreaterThanZero():
						alarmMain=preload("res://players/weapons/alarm_weapon_main_scene.tscn").instantiate()
						add_child(alarmMain)
						print("Mega:set_all values to Alarm weapon")
						deductWeaponEnergy()
				#if alarmSignalInstanceArray.has(null):#find(null,0)==-1:
					##checks if all values are null,if not they're no 
					##null values,then it'll return -1
				elif alarmMain!=null:
					if alarmMain.changeState==false:
						alarmMain.changeState=true
			6:
				if WeaponEnergyGreaterThanZero():#checkIfWeaponEnergyLessEqualZero()==false:
					if satellite_SatelliteMini==null:
						satellite_SatelliteMini=satellite_Weapon.instantiate()
						add_child(satellite_SatelliteMini)
						satellite_SatelliteMini.global_position=global_position-Vector2(0,20)
						deductWeaponEnergy()
			9:
				
				#if MegamanAndItems.weapon1energy > 0 and rCoilNo == 0:
					#MegamanAndItems.weapon1energy -= 3
				if WeaponEnergyGreaterThanZero():
					rCoilNo += 1
					rush_coil_instance = rush_coil.instantiate()
					get_parent().add_child(rush_coil_instance)
					if anim.flip_h == true:
						rush_coil_instance.global_position = Vector2(global_position.x + 20, global_position.y - 50)
					elif anim.flip_h == false:
						rush_coil_instance.global_position = Vector2(global_position.x - 20, global_position.y - 50)  #100
					if rush_coil_instance:
						print("Rush has spawned")
						rush_coil_instance.connect("tree_exited", rCoilLeft)
					deductWeaponEnergy()
				if rCoilNo!=0 and useBuster_WhenRCoil==true:
					projectile = lemon.instantiate()
					get_parent().add_child(projectile)
					if anim.flip_h==false:
						projectile.direction="left"
						if is_on_floor():
							projectile.global_position = $all_proj_spawn_points/ground_left.global_position
						elif not is_on_floor():
							anim.play("shoot_in_air")
							projectile.global_position = $all_proj_spawn_points/air_left.global_position
					else:
						projectile.direction="right"
						if is_on_floor():
							projectile.global_position = $all_proj_spawn_points/ground_right.global_position
						elif not is_on_floor():
							anim.play("shoot_in_air")
							projectile.global_position = $all_proj_spawn_points/air_right.global_position
					$all_sounds/shoot.play()
						
			10:
				#if MegamanAndItems.weapon2energy > 0:
					#MegamanAndItems.weapon2energy -= 3
					rush_jet_instance = rush_jet.instantiate()
					get_parent().add_child(rush_jet_instance)
					if anim.flip_h == true:
						rush_jet_instance.global_position = Vector2(global_position.x, global_position.y - 100)  #+50
						rush_jet_instance.direction = "right"
					elif anim.flip_h == false:
						rush_jet_instance.global_position = Vector2(global_position.x, global_position.y - 100)
						rush_jet_instance.direction = "left"
			11:
				#if MegamanAndItems.weapon3energy > 0:
					#MegamanAndItems.weapon3energy -= 2
					const MISSILE = preload("res://players/weapons/missile.tscn")
					var missile_instance = MISSILE.instantiate()
					get_parent().add_child(missile_instance)
					missile_instance.global_position = global_position
					match anim.flip_h:
						true:
							missile_instance.direction = "right"
						false:
							missile_instance.direction = "left"
		
	#activeUseOfWeaponSection
	if rush_coil_instance!=null and rush_coil_instance.just_landed==true:
		useBuster_WhenRCoil=true
	else:useBuster_WhenRCoil=false
	#if GlobalScript.weapon_number==1:
			#if alarmSignalInstance!=null and alarmSignalInstance.changeState==false and alarmSignalInstance2!=null and alarmSignalInstance2.changeState==false:
				#alarmSignalInstance.global_position=global_position+Vector2(-20,-20)
				#alarmSignalInstance2.global_position=global_position+Vector2(20,-20)
	#elif GlobalScript.weapon_number!=1:
		#if alarmSignalInstance!=null and alarmSignalInstance2!=null:
			#alarmSignalInstance.queue_free()
			#alarmSignalInstance2.queue_free()

#Function to actively check your weapon and their state and change them.
func activeUseOfWeapons():
	#clean_Dead_Objects_from_Array(alarmSignalInstanceArray)
	if GlobalScript.weapon_number==1:
		pass
	elif GlobalScript.weapon_number!=1:
		if alarmMain!=null:
			alarmMain.queue_free()

	if GlobalScript.weapon_number==6:
		if satellite_SatelliteMini!=null:
			if anim.flip_h==false:
				satellite_SatelliteMini.global_position.x=global_position.x+20
			elif anim.flip_h==true:
				satellite_SatelliteMini.global_position.x=global_position.x-20
	else:
		if satellite_SatelliteMini!=null:
			satellite_SatelliteMini.queue_free()
func WeaponEnergyGreaterThanZero():
	if MegamanAndItems.weaponEnergy.has(GlobalScript.weapon_number):
		return MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]>0
	
func deductWeaponEnergy():
	if MegamanAndItems.weaponEnergy.has(GlobalScript.weapon_number):
		
		var costofWeapon=MegamanAndItems.weaponEnergyCost[GlobalScript.weapon_number]
		#var weaponEnergy=MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]
		#not using value above since it doesnt alter the value of weaponEnergy dictionary
		#MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]-=
		if MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]>0:
			#weaponEnergy-=costofWeapon
			MegamanAndItems.weaponEnergy[GlobalScript.weapon_number]-=costofWeapon
			print("Mega.deductWeaponEnergy():Weapon Energy Deducted by=>",costofWeapon)
			#print(weaponEnergy)
			#print(MegamanAndItems.weaponEnergy[GlobalScript.weapon_number])
		else:
			#return
			print("Mega.deductWeaponEnergy():Weapon Energy <=0")
#Function to check it Rush Coil has left or not.
func rCoilLeft():
	rCoilNo -= 1
	print(name, ":rCoilLeft func active")
	print("rCoilNo[post Exit]:", rCoilNo)
	#suppsoed to be 0 after deduction by 1
	if rush_coil_instance:
		rush_coil_instance.disconnect("tree_exited", rCoilLeft)

func clean_Dead_Objects_from_Array(arr:Array):
	for i in range(arr.size()):
		if !is_instance_valid(arr[i]):#arr[i]!=null && 
			arr[i]=null
	return arr
func _on_anim_animation_finished():
	match anim.animation:
		"shoot_run":
			$anim.play("run")

		"shoot_idle":
			$anim.play("idle")

		"shoot_in_air":
			$anim.play("jump")
		"shoot_on_ladder":
			print("done")
			anim.play("climb")
			anim.pause()
		"spawn":
			player_ready = true
			$hitbox/CollisionShape2D.disabled = false
		"stun_air":
			disable_input = false
			is_stunned = false
			stop = false
			if is_on_floor():
				anim.play("idle")
			elif not is_on_floor():
				anim.play("jump")
		"climb_transition":
			if is_on_floor():
				anim.play("idle")
			else:
				anim.play("jump")


var was_leaving = false


func _on_change_climb_detector_area_entered(area):
	if area.is_in_group("ladders"):
		was_leaving = false


func _on_change_climb_detector_area_exited(area):
	if area.is_in_group("ladders"):
		was_leaving = true


var near_ladder = false

var enemyOrHazardHurtValue=0
func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy"):
		if GlobalScript.playerhasbeenhit == false:
			GlobalScript.playerhasbeenhit = true
			GlobalScript.previous_health = GlobalScript.health  #previous health used to check increasign health,collects the health of the player
			if not GlobalScript.player_god_mode:
				GlobalScript.health -= area.get_parent().playerdamagevalue  #this transfers a value of damage from the enemy to the player  #2,before,the player's health actually gets reduced
			$all_sounds/stun.play()
			anim.play("stun_air")
			climb = false
	if area.is_in_group("ladders"):
		near_ladder = true
	if area.is_in_group("rushjet"):
		onrush = true
	if area.is_in_group("deathzone"):
		GlobalScript.health = 0
	#if area.is_in_group("capsules"):
		#$all_sounds/energyup.play()
		pass


func _on_hitbox_area_exited(area):
	if area.is_in_group("ladders"):
		near_ladder = false
		climb = false
		#print("Megaman:About to leave ladder [area_exited]")


#var
var ladder_collider: Object


func _on_hitbox_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
	if area.is_in_group("ladders"):
		ladder_collider = area.shape_owner_get_owner(area_shape_index)


func _on_hitbox_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	pass


func _on_restart_timer_timeout():
	if GlobalScript.lives > 0:
		get_tree().reload_current_scene()
		#MegamanAndItems.reload_palette()
	elif GlobalScript.lives <= 0:
		get_tree().paused=false
		GlobalScript.lastStageEntered = get_tree().current_scene.scene_file_path
		GlobalScript.lives = GlobalScript.max_lives
		get_tree().change_scene_to_file("res://levels/game_over_screen.tscn")
		
		#GlobalScript.lives = 3


#func change_collisions_old():
#if anim.animation==("jump"):
#if anim.flip_h==true:
#$CollisionShape2D.position=Vector2(10.333,-2.667)
#elif anim.flip_h==false:
#$CollisionShape2D.position=Vector2(-8.333,-2.667)
#else:
#$CollisionShape2D.position=Vector2(2.667,3.333)


func _on_display_timer_timeout():
	$weapon_display.visible = false


func delete_weapons():
	if GlobalScript.weapon_number != 7:
		get_tree().call_group("rush_coil", "delete")
	elif GlobalScript.weapon_number != 8:
		get_tree().call_group("rush_jet", "delete")


func _on_timer_switch_cameras_timeout():
	$player_camera.position_smoothing_enabled = false
	stop = false
	trans_left = false
	trans_right = false
	trans_up = false
	trans_down = false


func change_collisions():
	if anim.animation == "dash":
		$AnimationPlayer.play("dash")
	else:
		$AnimationPlayer.play("others")


func _on_start_timer_timeout():
	pass  # Replace with function body.
	const SPAWN_IN_EFFECT = preload("res://miscellenaous/effects/spawn_in_effect.tscn")
	var spawn_in_effect_instance = SPAWN_IN_EFFECT.instantiate()
	spawn_in_effect_instance.global_position.x = global_position.x
	spawn_in_effect_instance.global_position.y = global_position.y - 500
	get_parent().add_child(spawn_in_effect_instance)
	#if we are entering a new scene,save our starting point
	#might activate again if ejterign or restarting levels causes issues.
	if GlobalScript.restarted_level == false:  
		GlobalScript.save_savepoint_data()


func _on_animation_player_animation_finished(_anim_name):
	pass  # Replace with function body.


func _on_animation_player_2_animation_finished(anim_name):
	pass  # Replace with function body.
	match anim_name:
		"screen_shake":
			print("Megaman:AnimationPlayer:Screen shake done")


func _on_dash_timer_timeout():
	velocity.x = 0


func _on_visible_on_screen_notifier_2d_screen_exited():
	#GlobalScript.health=0
	pass


func _on_bgm_finished():
	pass  # Replace with function body.


func _on_trigger_leave_timer_timeout():
	if playLeaveBGM==true:
		get_tree().change_scene_to_file("res://levels/robot_master_menu.tscn")#"res://levels/test stages/end_of_level_score_screen.tscn"
	elif playLeaveBGM==false:
		get_tree().change_scene_to_file("res://levels/challenges_menu.tscn")
	#GlobalScript.las


func _on_leave_timer_timeout():
	if $HUD/fade_out_effect/AnimationPlayer.current_animation != "fade_out":
		#$fade_out_effect.visible=true
		$HUD/fade_out_effect/AnimationPlayer.play("fade_out")
		$all_timers/trigger_leave_timer.start()


func _on_whistle_idle_trigger_timer_timeout():
	anim.play("whistle_idle")
	print(name, "->whistle_timer: with a wait _time of:", $whistle_idle_trigger_timer.get("wait_time"), "::(s) ::timed out")


func _on_jump_timer_timeout() -> void:
	$anim.play("idle")


func _on_detect_floor_types_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("iceTiles"):
		onIce = true
	if body is Conveyor:
		pass



func _on_detect_floor_types_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("iceTiles"):
		onIce = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	#Hitbox Codes for Body Nodes like Tiles
	if body.is_in_group("spikeTiles"):
		if GlobalScript.playerhasbeenhit == false:
			GlobalScript.playerhasbeenhit = true
			GlobalScript.health-=8
			$all_sounds/stun.play()
			stun(deltaAlt)#using 0.1 since its close to delta(0.19998,i think)
			anim.play("stun_air")

func _on_player_constants_checker_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("waterTiles"):
		inWater=true
		var waterSplash=preload("res://miscellenaous/effects/water_enter_exit_effect.tscn").instantiate()
		waterSplash.position=position+Vector2(0,11)
		get_parent().call_deferred("add_child",waterSplash)


func _on_player_constants_checker_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("waterTiles"):
		inWater=false
		var waterSplash=preload("res://miscellenaous/effects/water_enter_exit_effect.tscn").instantiate()
		waterSplash.position=position+Vector2(0,15)
		get_parent().call_deferred("add_child",waterSplash)


func _on_level_cleared_finished() -> void:
	enabledLeavingCode=true


func _on_hit_blink_timer_timeout() -> void:
	#flip b/n visible and not visible to create blink effect
	anim.visible=!anim.visible


func _on_check_dash_released_timer_timeout() -> void:
	#if not Input.is_action_pressed("dash"):
		#$dash/Timer.stop()
	pass
