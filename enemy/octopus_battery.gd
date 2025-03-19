extends enemy
@export_category("Movement(Major movement set)")
@export var InitialDirection:String="left"
var SPEED = 7000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export_category("Movement(Mini initial direction setter)")
@export var InitialDirection_Mini:String

@export var enemyVariant:String="none"
var abouttomove_down=0;var abouttomove_left=0
var hasplayedReversedAnimationOnce:bool=false
var hasplayedForwardAnimationOnce:bool=false
var animationVariant:String
func _ready():
	
	health=5
#var intial
func _physics_process(delta):
	#print("Octopus battery:aboutto_left":abouttomove_left)
	#$health.text=str(health)
	playerdamagevalue=3
	spawn_collectables()
	match enemyVariant:
		"none":
			animationVariant="red"
		"ice":
			animationVariant="ice"
	match InitialDirection_Mini:
		"up":
			velocity.y=-SPEED*delta
		"down":
			velocity.y=SPEED*delta
		"left":
			velocity.x=-SPEED*delta
		"right":
			velocity.x=SPEED*delta
	match InitialDirection:
		"up":
			pass
			if is_on_ceiling():
				abouttomove_down+=1
				if abouttomove_down<100:
					velocity.y=0
				if abouttomove_down>=100:
					InitialDirection_Mini="down"
					abouttomove_down=0
			if is_on_floor():
				abouttomove_down+=1
				if abouttomove_down<100:
					velocity.y=0
				if abouttomove_down>=100:
					InitialDirection_Mini="up"
					abouttomove_down=0
		"left":
			if is_on_wall():
				if $RayCast2D_left.is_colliding():
					abouttomove_left+=1
					if abouttomove_left<100:
						velocity.x=0
					if abouttomove_left>=100:
						InitialDirection_Mini="right"
						abouttomove_left=0
				if $RayCast2D_right.is_colliding():
					abouttomove_left+=1
					if abouttomove_left<100:
						velocity.x=0
					if abouttomove_left>=100:
						InitialDirection_Mini="left"
						abouttomove_left=0
	if InitialDirection=="up":
		if velocity.y==0:
			play_anim2=0
			play_anim+=1
			hasplayedForwardAnimationOnce=false
			if hasplayedReversedAnimationOnce==false:
				$AnimatedSprite2D.play_backwards(animationVariant)
				hasplayedReversedAnimationOnce=true
			#if play_anim==1:
				#$AnimatedSprite2D.play_backwards(animationVariant)
		elif velocity.y!=0:
			play_anim=0
			play_anim2+=1
			hasplayedReversedAnimationOnce=false
			if hasplayedForwardAnimationOnce==false:
				$AnimatedSprite2D.play(animationVariant)
				hasplayedForwardAnimationOnce=true
			#if play_anim2==1:
				#$AnimatedSprite2D.play(red)
	elif InitialDirection=="left":
		if velocity.x==0:
			play_anim2=0
			play_anim+=1
			hasplayedForwardAnimationOnce=false
			if hasplayedReversedAnimationOnce==false:
				$AnimatedSprite2D.play_backwards(animationVariant)
				hasplayedReversedAnimationOnce=true
			#if play_anim==1:
				#$AnimatedSprite2D.play_backwards(animationVariant)
		elif velocity.x!=0:
			play_anim=0
			play_anim2+=1
			hasplayedReversedAnimationOnce=false
			if hasplayedForwardAnimationOnce==false:
				$AnimatedSprite2D.play(animationVariant)
				hasplayedForwardAnimationOnce=true
			#if play_anim2==1:
				#$AnimatedSprite2D.play(animationVariant)
	move_and_slide()
var play_anim=0;var play_anim2=0


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass
