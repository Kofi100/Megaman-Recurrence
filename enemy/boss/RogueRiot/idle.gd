extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
#@onready var attack_timer: Timer = $"../../Timers/attack_timer"
@onready var rogue_riot: CharacterBody2D = $"../.."

@export var timer:Timer
var movement_states
var current_attack=-1#0
var just_entered_scene:bool=false
func _ready() -> void:
	#animated_sprite_2d.play("idle")
	if not timer.is_connected("timeout",end_attack):
		timer.connect("timeout",end_attack)
	just_entered_scene=true
	

func Enter():
	#print(current_attack)
	#current_attack+=1
	current_attack=(current_attack+1)%2
	#print("new:",current_attack)
	animated_sprite_2d.play("idle")
	#if not timer.is_connected("timeout",end_attack):
		#timer.connect("timeout",end_attack)
	#current_attack+=1
	if just_entered_scene:
		timer.start(3)
		just_entered_scene=false
	else:
		timer.start(1.5)
	#this resets current_Attack before the attack completes
	#if current_attack==1:
		#current_attack=0

	#print(current_attack)
	
func Exit():
	#placed this here to prevent future issues
	#print(current_attack)
	#timer.disconnect("timeout",end_attack)
	
	pass



func Physics_Update(delta):
	
	#if current_attack>1:
		#current_attack=0
	#print("rogue riot: current_attack:",current_attack)
	pass
	#print(current_attack)
	#await get_tree().create_timer(3).timeout
	#await animated_sprite_2d.animation_finished
	#transition.emit(self,"ground_stomp")



func end_attack():
	#print("yh,rogue riot is ending its attack")
	#var distance:float=rogue_riot.calculate_player_distance()
	print("rogue_riot.distance_x: ",rogue_riot.distance_x)
	if abs(rogue_riot.distance_x)<=95:
		var chance=randi_range(1,100)
		if chance>75:#25% chance
			transition.emit(self,"ground_stomp")
		if chance<=75:
			transition.emit(self,"spiky_ball")
	if abs(rogue_riot.distance_x)>95:
		var chance=randi_range(1,100)
		if chance>75:
			transition.emit(self,"laser_attack")
		elif chance<=75:
			transition.emit(self,"jump")
	#if current_attack==0:
		#transition.emit(self,"ground_stomp")
	#elif current_attack==1:
		#transition.emit(self,"jump")
