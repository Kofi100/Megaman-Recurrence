extends CharacterBody2D


const SPEED = 5000.0
const JUMP_VELOCITY = -400.0
var gotPlayerPos=false
var wasNotOnFloor=true
var timeMult=2.0
func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _process(delta: float) -> void:
	#if not is_on_floor():
		#velocity.y += 0.25 * delta
	time+=delta*timeMult
	move_and_slide()
	
	

#var time
func _physics_process(delta: float) -> void:
	#time+=1*delta
	# Add gravity.

	
	#Get and move towards the player's Position in a projectile motion form once
	#if gotPlayerPos==false:
		#var displacementX=GlobalScript.playerposx-global_position.x
		#var displacementY=GlobalScript.playerposy-global_position.y
		##var angle=atan2(displacementY,displacementX)
		##var target_velocity = Vector2(cos(angle), sin(angle)) * SPEED
 ## Calculate the target direction
		#var height=5
		#
		#var velocityY=sqrt(-2*get_gravity().y*height)
		#var airtime=sqrt(-2*height/get_gravity().y)+sqrt(2*(displacementY-height)/get_gravity().y)
		#var velocityX=displacementX/airtime
		#velocity=Vector2(velocityX,velocityY)
		#
		#
		#
		## Apply horizontal movement towards the target while maintaining gravity
		##(and hopefully throw object accurately to player's position
		##orignal
		##velocity.y=sin(displacementY)*SPEED*delta
		##velocity.x=cos(displacementX)*SPEED*delta
		#
		##ai-suggested
		##velocity.x = lerp(velocity.x, target_velocity.x, 0.1)  # Smooth transition
		##was trying to mimic physics irl lol 😆
		##velocity.y=velocity.x*tan(deg_to_rad(45))-((980*pow(velocity.x,2))/(2*pow(500*cos(deg_to_rad(45)),2)))*delta
#
		##velocity.y=-displacementY*1000*delta
		##velocity.y=-(pow(4000,2))/(2*980)*delta
		##print(displacementY)
		#gotPlayerPos = true  # Lock on to the player
	
	if is_on_floor() and wasNotOnFloor==true:
		velocity=Vector2.ZERO
		#$AnimatedSprite2D.visible=false
		#var exp=preload("res://enemy/boss/count_bomb_explosion_radius.tscn").instantiate()
		#add_child(exp)
		#exp.global_position=global_position
		#exp.parent=self
		#exp.playerdamagevalue=5
		print("DisX:",GlobalScript.playerposx-global_position.x)
		wasNotOnFloor=false
		#queue_free()
	#move_and_slide()

func _throwtoPlayer(height:float):
		
		var displacementX=GlobalScript.playerposx-global_position.x
		var displacementY=abs(GlobalScript.playerposy-global_position.y)
		
		var velocityY=-sqrt(2 * 0.25 * height)
		var a=sqrt(2* height/0.25)
		var b=sqrt(2*(displacementY+height)/0.25)
		var airtime=a + b
		#airtime*=0.01
		
		var velocityX=displacementX/airtime
		
		#velocity=Vector2(displacementX/2,-(displacementY/2))
		velocity=Vector2(velocityX,velocityY)
		
		#var tween=create_tween()
		#tween.tween_property(self,"velocity",Vector2(velocityX,velocityY),.2)
		print("+++++++++++++++++++++++++++++++++++++++++++++")
		print("Height:",height)
		print("Airtime:",airtime)
		print("a:",a)
		print("b:",b)
		print("displacementY:",displacementY)
		print("displacementX:",displacementX)
		print("velocityY:",velocityY)
		print("velocityX:",velocityX)
		print("+++++++++++++++++++++++++++++++++++++++++++++")
var throw_direction:Vector2
var initial_speed:float
var time=0.0
var initial_position:Vector2
var throw_angle_degree:float

func launch(initial_pos:Vector2,direction:Vector2,desired_distance:float,desired_angle_deg:float):
	initial_position=initial_pos
	throw_direction=direction.normalized()
	throw_angle_degree=desired_angle_deg
	initial_speed=pow(desired_distance*get_gravity().y/sin(2*deg_to_rad(desired_angle_deg)),0.5)
	global_position=initial_position
	time=0.0
	
	
	
func _on_timer_timeout() -> void:
	#var a=preload("res://miscellenaous/effects/indicator_or_tracer.tscn").instantiate()
	#get_parent().add_child(a)
	#a.global_position=global_position
	#var exp=preload("res://enemy/boss/count_bomb_explosion_radius.tscn").instantiate()
	#add_child(exp)
	#exp.global_position=global_position
	#exp.parent=self
	#exp.playerdamagevalue=5
	pass
	#print("grenade detonate")
