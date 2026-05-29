extends State
@onready var intro_timer: Timer = $"../../Timers/intro_timer"
@onready var hud_boss_bar: CanvasLayer = $"../../HUD_BossBar"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var rogue_riot: CharacterBody2D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	#intro_timer.connect("timeout",IntroDone)
	animated_sprite_2d.animation_finished.connect(IntroDone)
	GlobalSignalBus.boss_trigger.connect(start_boss_intro_or_wait_timer)
func Enter():
	rogue_riot.deactivate_gravity=true
	state=MiniState.NOT_READY
	#intro_timer.start()
enum MiniState{FALL,STOMP,NOT_READY}
var state:MiniState
func Exit():
	animated_sprite_2d.animation_finished.disconnect(IntroDone)

func Update(_delta:float):
	pass
var triggered_camera_shake:bool=false
func Physics_Update(_delta:float):
	match state:
		MiniState.FALL:
			rogue_riot.deactivate_gravity=false
			animated_sprite_2d.play("fall_down")
			animated_sprite_2d.frame=0
			if rogue_riot.is_on_floor():
				state=MiniState.STOMP
				animated_sprite_2d.play("intro")
				GlobalSignalBus.emit_signal("trigger_camera_shake", 5, .15)
		MiniState.STOMP:
			pass
			match animated_sprite_2d.frame:
				1,3,5,6:
					if triggered_camera_shake==false:
						GlobalSignalBus.emit_signal("trigger_camera_shake", 2, .1)
						triggered_camera_shake=true
				0,2,4:
					triggered_camera_shake=false
		MiniState.NOT_READY:
			rogue_riot.deactivate_gravity=true

func start_boss_intro_or_wait_timer():
	#intro_timer.start()
	#await GlobalScreenTransitionTimer.timeout
	state=MiniState.FALL
	#animated_sprite_2d.play("intro")


func IntroDone():
	match animated_sprite_2d.animation:
		"intro":
			if state==MiniState.STOMP:
				hud_boss_bar.FillBarUp.emit()
				await get_tree().create_timer(1).timeout
				transition.emit(self,"idle")
