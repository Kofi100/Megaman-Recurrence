extends State
@export var shadowman:CharacterBody2D
@export var testTimer:Timer
@export var animatedSprite:AnimatedSprite2D
@export var topMarker:Marker2D
# Called when the node enters the scene tree for the first time.
func Enter():
	shootNumber=0
	#if testTimer: #i think i used this to test how many times shadowman could shoot over time.
		##testTimer.start()
		#testTimer.connect("timeout",TimerUp)
	if animatedSprite:
		animatedSprite.connect("animation_finished",_on_animated_sprite_2d_animation_finished)
		animatedSprite.stop()
		animatedSprite.play("Throw")

func Exit():
	#testTimer.disconnect("timeout",TimerUp)
	animatedSprite.disconnect("animation_finished",_on_animated_sprite_2d_animation_finished)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta):
	if shadowman and testTimer and animatedSprite:
		#if animatedSprite.frame==
		pass
	if shootNumber==1:
		testTimer.stop()
	pass
var shootNumber=0
func TimerUp():
	if shootNumber<=2 and topMarker:
		var blades=preload("res://enemy/boss/shadow_blade_shadow_man.tscn").instantiate()
		
		get_parent().add_child(blades);blades.global_position=topMarker.global_position
		blades.Shadowman=shadowman
		shootNumber=shootNumber+1


func _on_animated_sprite_2d_animation_finished():
	match animatedSprite.animation:
		"Throw":
			if shootNumber==1:
				print("Throw()!")
				transition.emit(self,"ShadowStop")
				#animatedSprite.play("Stop")
			if shootNumber<=1 and topMarker:
				animatedSprite.play("Throw")
				var blades=preload("res://enemy/boss/shadow_blade_shadow_man.tscn").instantiate()
				get_parent().add_child(blades);blades.global_position=topMarker.global_position
				blades.Shadowman=shadowman
				var Playerdis_x=GlobalScript.playerposx-blades.global_position.x#GlobalScript.player.global_position.xGlobalScript.player.global_position.y
				var Playerdis_y=GlobalScript.playerposy-blades.global_position.y
				blades.angle_to_shoot=atan2(Playerdis_y,Playerdis_x)
				shootNumber=shootNumber+1
				
