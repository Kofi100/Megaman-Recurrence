#@tool
extends CharacterBody2D
class_name FallingBridgeTile
#var LeftDetect=false
#var RightDetect=false
@export var spriteFrame:int=0
var time:float=0
@export var correctXPosition:bool=false
@export var timeToLeavePlatform:float=3.0
@export var fallSpeed:float=100
var playerOnTop:bool=false
@export var original_Position:Vector2
var hasGottenOGPos:bool=false
var timeShake=0
func _ready() -> void:
	
	#original_Position=global_position
	pass

func _physics_process(delta: float) -> void:
	var leftTile
	if spriteFrame<($Sprite2D.vframes*$Sprite2D.hframes):
		$mainPiece/Sprite2D.frame=spriteFrame
	#if is_inside_tree() and hasGottenOGPos==false:
		#await get_tree().process_frame
		#original_Position=global_position
		##print(global_position,original_Position)
		#hasGottenOGPos=true
		##print(hasGottenOGPos)
	#else:
		#hasGottenOGPos=false
		#print(hasGottenOGPos)
	#if correctXPosition:
		#var collectedglobalposition=global_position.x/8
		#global_position.x=int(collectedglobalposition)*8
		#original_Position=global_position
		#correctXPosition=false

	
	if Engine.is_editor_hint():
		time+=1*delta
		#var left_collider = $RayCast2DL.get_collider() if $RayCast2DL.is_colliding() else null
		##print(name,left_collider)
		$RayCast2DL.force_raycast_update()
		$RayCast2DR.force_raycast_update()
		#update_Sprites()
		#if fmod(time,5)<0.05:#==0:
			#notify_property_list_changed()
			#$Sprite2D.queue_redraw()
			#print("time 5")
		#print(fmod(time,5))
		#queue_redraw()
		#await get_tree().physics_frame

		pass
	else:
	#leftTile
		pass
		time=0

		if GlobalScreenTransitionTimer.time_left<=0:
			if playerOnTop:
				timeShake+=1
				#if timeShake%20==1:
				if not $warning_Timer.is_stopped():
					if timeShake%20==1:
						$mainPiece.global_position.x-=1
					elif timeShake%20==10:
						$mainPiece.global_position.x+=1
					#if $AnimationPlayer.current_animation!="warning":
						#$AnimationPlayer.play("warning")
				elif not $fall_Timer.is_stopped():
					#$AnimationPlayer.play("RESET")
					
					$mainPiece.velocity.y=50
					#if velocity.y>0 and $VisibleOnScreenNotifier2D.is_on_screen():
					$mainPiece.move_and_collide(velocity*delta)
		if GlobalScreenTransitionTimer.time_left>0:
			$mainPiece.position=Vector2.ZERO
			playerOnTop=false
	#if LeftDetect and RightDetect:
		#$Sprite2D.frame=1
	#elif LeftDetect and not RightDetect:
		#$Sprite2D.frame=2
	#elif not LeftDetect and RightDetect:
		#$Sprite2D.frame=0
	#print(name,LeftDetect)
	#update_Sprites()
	#spriteFrame=$Sprite2D.get_frame()
func update_Sprites():
	#notify_property_list_changed()
	var leftDetect=$RayCast2DL.is_colliding() and $RayCast2DL.get_collider() is FallingBridgeTile
	var rightDetect=$RayCast2DR.is_colliding() and $RayCast2DR.get_collider() is FallingBridgeTile
	if leftDetect:#.is_in_group("FallingBridgeTile"): 
		#print($RayCast2DL.get_collider() is FallingBridgeTile)
		if not $RayCast2DR.is_colliding() or ($RayCast2DR.is_colliding() and not $RayCast2DR.get_collider() is FallingBridgeTile):#.is_in_group("FallingBridgeTile")):
			$Sprite2D.frame=2
	if rightDetect:
		if not $RayCast2DL.is_colliding() or ($RayCast2DL.is_colliding() and not $RayCast2DL.get_collider() is FallingBridgeTile):
			$Sprite2D.frame=0
	if leftDetect:#$RayCast2DL.is_colliding() and $RayCast2DL.get_collider() is FallingBridgeTile:
		if rightDetect:#$RayCast2DR.is_colliding() and $RayCast2DR.get_collider() is FallingBridgeTile:
			$Sprite2D.frame=1
func _enter_tree() -> void:
	if hasGottenOGPos==false:
		original_Position=global_position
		hasGottenOGPos=true
func _notification(what: int) -> void:
	if what ==NOTIFICATION_TRANSFORM_CHANGED:
		pass
func _on_area_2dl_body_entered(body: Node2D) -> void:
	if body.is_in_group("FallingBridgeTile"):
		#LeftDetect=true
		pass


func _on_area_2dl_body_exited(body: Node2D) -> void:
	if  body.is_in_group("FallingBridgeTile"):
		#LeftDetect=false
		pass


func _on_area_2dr_body_entered(body: Node2D) -> void:
	if  body.is_in_group("FallingBridgeTile"):
		#RightDetect=true
		pass

func _on_area_2dr_body_exited(body: Node2D) -> void:
	if  body.is_in_group("FallingBridgeTile"):
		#RightDetect=false
		pass


func _on_detect_player_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_detect_player_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_constants_checker_area2d"):
		if playerOnTop==false:
			playerOnTop=true
			$warning_Timer.start()
		#$fall_Timer.start()


func _on_fall_timer_timeout() -> void:
	playerOnTop=false


func _on_warning_timer_timeout() -> void:
	$fall_Timer.start()
	$mainPiece.position.x=0#global_position.x=original_Position.x
