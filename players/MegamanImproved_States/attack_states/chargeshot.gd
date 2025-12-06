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
	if Input.is_action_pressed("shoot"):
		MegamanAndItems.charge_timer+=1
		animation_played_once=false
	else:
		MegamanAndItems.charge_timer=0
		
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

func _animations_finished():
	match animations.animation:
		"shoot_idle","shoot_run","shoot_in_air":
			player_context_megaman.is_attacking=false
			
