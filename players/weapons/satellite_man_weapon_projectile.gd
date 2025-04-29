extends CharacterBody2D
var IsAimed:bool=false
var angleToGo
var SPEED:float=10000
var enemy_disX
var enemy_disY
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#if IsAimed==false:
		#
		#IsAimed=true
	calculate_Angle(enemy_disX,enemy_disY,delta)
	move_and_slide()
	pass

func calculate_Angle(distanceX,distanceY,delta):
	angleToGo=atan2(distanceY,distanceX)
	velocity.y=sin(angleToGo)*SPEED*delta
	velocity.x=cos(angleToGo)*SPEED*delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.get_parent().health-=5
		queue_free()
