extends State
@onready var flameman: CharacterBody2D = $"../.."
@onready var fire_timing_timer: Timer = $"../../timers/fire_timing_timer"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var attack_times=0
# Called when the node enters the scene tree for the first time.
func _ready():
	fire_timing_timer.connect("timeout",fire_timing_timeout)
	animated_sprite_2d.animation_finished.connect(animated_sprite_finished_animation)

func Enter():
	fire_timing_timer.start()
	animated_sprite_2d.play("flame_thrower")
	
	#flameman.animated_sprite_2d.connect("animation_finished",)

func Exit():
	pass
	attack_times=0
	fire_timing_timer.one_shot=false

func Update(_delta:float):
	pass

func Physics_Update(_delta:float):
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func fire_timing_timeout():
	#if attack_times<2:
		#flameman.animated_sprite_2d.play("flame_thrower")
		#attack_times+=1
		
	#else:
		#fire_timing_timer.one_shot=true
		transition.emit(self,"idle")

func animated_sprite_finished_animation():
	pass
	#spawn fire projectile here
