extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
#@onready var attack_timer: Timer = $"../../Timers/attack_timer"
@export var rogue_riot: CharacterBody2D

@export var timer: Timer
var movement_states
var current_attack = -1  #0
var just_entered_scene: bool = false


func _ready() -> void:
	#animated_sprite_2d.play("idle")
	if not timer.is_connected("timeout", end_attack):
		timer.connect("timeout", end_attack)
	just_entered_scene = true


func Enter():
	#print(current_attack)
	#current_attack+=1
	current_attack = (current_attack + 1) % 2
	#print("new:",current_attack)
	animated_sprite_2d.play("idle")
	#if not timer.is_connected("timeout",end_attack):
	#timer.connect("timeout",end_attack)
	#current_attack+=1
	#if just_entered_scene:
	#timer.start(3)
	#just_entered_scene=false
	#else:
	timer.start(1)  #.5
	rogue_riot.activated = true
	
	#this resets current_Attack before the attack completes
	#if current_attack==1:
	#current_attack=0

	#print(current_attack)


func Exit():
	#placed this here to prevent future issues
	#print(current_attack)
	#timer.disconnect("timeout",end_attack)

	pass


var allowed_attack_no = []
var allowed_ground_stomp: int = 0
var allowed_spiky_ball: int = 0


func Physics_Update(_delta):
	#if current_attack>1:
	#current_attack=0
	#print("rogue riot: current_attack:",current_attack)
	pass
	#print(current_attack)
	#await get_tree().create_timer(3).timeout
	#await animated_sprite_2d.animation_finished
	#transition.emit(self,"ground_stomp")


#attack position guide
#close_distance:<70px# 40
#middle:70-140px#95px
#far:>140px#>95px
func end_attack():
	#lil code here to check if player is dead before rogue attacks
	#for a real robot sake
	if GlobalScript.health > 0:
		var player_distance = abs(rogue_riot.distance_x)
		if player_distance <= 70:
			var chance = randi_range(1, 100)
			if chance <= 75:  #25% chance
				allowed_ground_stomp += 1
				if allowed_ground_stomp > 2:
					allowed_ground_stomp = 0
					transition.emit(self, "spiky_ball")
					return

				transition.emit(self, "ground_stomp")
			if chance > 75:
				allowed_spiky_ball += 1
				if allowed_spiky_ball > 2:
					allowed_spiky_ball = 0
					transition.emit(self, "ground_stomp")
					return

				transition.emit(self, "spiky_ball")

		elif player_distance <= 140 and player_distance > 70:
			var chance = randi_range(1, 100)
			if chance > 75:  #25% chance
				allowed_ground_stomp += 1
				if allowed_ground_stomp > 2:
					allowed_ground_stomp = 0
					transition.emit(self, "spiky_ball")
					return

				transition.emit(self, "ground_stomp")
			if chance <= 75:
				allowed_spiky_ball += 1
				if allowed_spiky_ball > 2:
					allowed_spiky_ball = 0
					transition.emit(self, "ground_stomp")
					return

				transition.emit(self, "spiky_ball")
		elif player_distance > 140:
			var chance = randi_range(1, 100)
			if chance <= 75:
				transition.emit(self, "laser_attack")
			elif chance > 75:
				transition.emit(self, "jump")
	pass
	#if current_attack==0:
	#transition.emit(self,"ground_stomp")
	#elif current_attack==1:
	#transition.emit(self,"jump")
