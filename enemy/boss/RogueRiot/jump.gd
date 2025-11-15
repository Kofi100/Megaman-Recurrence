extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var rogue_riot: CharacterBody2D = $"../.."
@onready var stomp_sound: SFX = $"../../SFX/stomp"

var jump_velocity:float=-300
var has_jumped:bool=false
var is_about_to_land:bool=false
var jump_times:int=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Enter():
	has_jumped=false
	is_about_to_land=false
	animated_sprite_2d.play("jump_up")

func Exit():
	has_jumped=false
	animated_sprite_2d.offset.y=0
	jump_times=0

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	if rogue_riot.is_on_floor():
		if animated_sprite_2d.frame==1 and animated_sprite_2d.animation=="jump_up":
			rogue_riot.velocity.y=jump_velocity
			if rogue_riot.distance_x<=0:
				rogue_riot.velocity.x=-250#/3
			elif rogue_riot.distance_x>0:
				rogue_riot.velocity.x=250#/3#200
			has_jumped=true
	if not rogue_riot.is_on_floor():
		#if rogue_riot.velocity.y>0:
			animated_sprite_2d.play("fall_down")
			animated_sprite_2d.frame=0
			is_about_to_land=true
	if  is_about_to_land and rogue_riot.is_on_floor() and animated_sprite_2d.animation=="fall_down":#velocity.y>0 and rogue_riot.is_on_floor() and has_jumped==true
		#jump_times+=1
		#print(jump_times)
		rogue_riot.velocity.x=0
		animated_sprite_2d.frame=1
		animated_sprite_2d.offset.y=1
		GlobalSignalBus.emit_signal("trigger_camera_shake",8,.1)
		stomp_sound.play()
		if Player.playerCharacter.is_on_floor():
			Player.playerCharacter.stun_temporarily(.5)

		#if jump_times<=3:
			#rogue_riot.velocity.y=jump_velocity
			#if rogue_riot.distance_x<=0:
				#rogue_riot.velocity.x=-250/3
			#elif rogue_riot.distance_x>0:
				#rogue_riot.velocity.x=250/3#200
			
		#await get_tree().create_timer(.1).timeout
		#animated_sprite_2d.stop()
		#print("yh")
		#elif jump_times>3:
		transition.emit(self,"idle")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
