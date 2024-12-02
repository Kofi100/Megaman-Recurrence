extends State
@export var shadowman:CharacterBody2D
#@export var testTimer:Timer#
@export var animatedSprite:AnimatedSprite2D
@export var linetouse:Line2D;@export var markerLineTop:Marker2D
@export var markOnPlayer:Sprite2D
func Enter():
	attackNo=0
	if markOnPlayer:
		markOnPlayer.visible=true
	if animatedSprite:
		animatedSprite.connect("animation_finished",AnimationFinished)

func Exit():
	pass
	animatedSprite.disconnect("animation_finished",AnimationFinished)
	markOnPlayer.visible=false

func Update(_delta:float):
	pass

func Physics_Update(delta):
	if shadowman and animatedSprite and markOnPlayer:
		animatedSprite.play("ThrowCritical")
		markOnPlayer.global_position=Vector2(GlobalScript.playerposx,GlobalScript.playerposy)

var attackNo=0
func AnimationFinished():
	match animatedSprite.animation:
		"ThrowCritical":
			if attackNo==3:
				transition.emit(self,"ShadowStop")
			
			if attackNo<=3:
				#var line=Line2D.new()
				
				#line.global_position=shadowman.global_position;
				#line.add_point(Vector2(0,-250))
				#line.add_point(Vector2(0,250))
				#line.default_color=Color.BLUE
				#line.z_index=3
				#print(line.z_index)
				#line.width=2#
				
			#print(dis_x,dis_y)
				
				#line.global_rotation_degrees=60#rad_to_deg(angle_to_shoot)
				
				#print(rad_to_deg(angle_to_shoot))
				#draw_line()
				var criticalBlades=preload("res://enemy/boss/shadow_blade_critical_boss.tscn").instantiate()
				get_parent().add_child(criticalBlades)
				if markerLineTop:
					criticalBlades.global_position=markerLineTop.global_position
				var dis_x=GlobalScript.playerposx-criticalBlades.global_position.x#GlobalScript.player.global_position.xGlobalScript.player.global_position.y
				var dis_y=GlobalScript.playerposy-criticalBlades.global_position.y
				var angle_to_shoot=atan2(dis_y,dis_x)
				linetouse.global_rotation=rad_to_deg(angle_to_shoot)
				criticalBlades.angle_to_shoot=angle_to_shoot
				
				attackNo+=1
				#velocity.y=sin(angle_to_shoot)*SPEED*delta
				#velocity.x=cos(angle_to_shoot)*SPEED*delta
			
