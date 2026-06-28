extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var rogue_riot: CharacterBody2D = $"../.."
@onready var ground_wave_spawn_position_left: Marker2D = $"../../ground_wave_spawn_position_left"
@onready var ground_wave_spawn_position_right: Marker2D = $"../../ground_wave_spawn_position_right"
@onready var stomp_sound: SFX = $"../../SFX/stomp"

var triggered_camera_shake: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func Enter():
	animated_sprite_2d.play("stomp")


func Exit():
	animated_sprite_2d.stop()
	triggered_camera_shake = false


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	#await get_tree().create_timer(3).timeout
	if animated_sprite_2d.frame == 2 and triggered_camera_shake == false:
		GlobalSignalBus.emit_signal("trigger_camera_shake", 3, .15)
		stomp_sound.play()
		if Player.playerCharacter.is_on_floor():
			Player.playerCharacter.stun_temporarily(.5)
		var energy_wave = preload("res://enemy/heavy_brawler_projectile_wave.tscn").instantiate()

		#energy_wave.global_position=rogue_riot.global_position
		#print(rogue_riot.distance_x)
		if rogue_riot.distance_x <= 0:
			energy_wave.global_position = ground_wave_spawn_position_left.global_position
			energy_wave.direction = "left"

		if rogue_riot.distance_x > 0:
			energy_wave.global_position = ground_wave_spawn_position_right.global_position
			energy_wave.direction = "right"
		get_tree().current_scene.add_child(energy_wave)
		triggered_camera_shake = true
	await animated_sprite_2d.animation_finished
	transition.emit(self, "idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
