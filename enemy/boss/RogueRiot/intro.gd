extends State
@onready var intro_timer: Timer = $"../../Timers/intro_timer"
@onready var hud_boss_bar: CanvasLayer = $"../../HUD_BossBar"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	intro_timer.connect("timeout",IntroDone)
func Enter():
	animated_sprite_2d.play("idle")
	intro_timer.start()

func Exit():
	pass

func Update(delta:float):
	pass

func Physics_Update(delta:float):
	pass

func IntroDone():
	hud_boss_bar.FillBarUp.emit()
	transition.emit(self,"idle")
