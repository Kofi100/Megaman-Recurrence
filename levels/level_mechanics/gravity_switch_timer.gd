extends Node2D
var player_within_range:bool=false
@export var starting_frame:int=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.frame=starting_frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $VisibleOnScreenNotifier2D.is_on_screen():
		player_within_range=true
	else:
		player_within_range=false
	
	if player_within_range:
		if $countdown_timer.is_stopped():
			$countdown_timer.start()
	
	$countdown_display.text=str(int($countdown_timer.time_left)+1)


func _on_area_of_effect_area_entered(area: Area2D) -> void:
	#if area.is_in_group("player_constants_checker_area2d"):
		#player_within_range=true
	pass


func _on_area_of_effect_area_exited(area: Area2D) -> void:
	#if area.is_in_group("player_constants_checker_area2d"):
		#player_within_range=false
		#Player.playerCharacter.reverse_gravity=false
		#if not $countdown_timer.is_stopped():
			#$countdown_timer.stop()
	pass

func _on_countdown_timer_timeout() -> void:
	if player_within_range:
		if $AnimatedSprite2D.frame==0:
			$AnimatedSprite2D.frame=1
		else:
			$AnimatedSprite2D.frame=0
		#$AnimatedSprite2D.frame= $AnimatedSprite2D.frame%2
		match $AnimatedSprite2D.frame:
			0:
				Player.playerCharacter.reverse_gravity=true
			1:
				Player.playerCharacter.reverse_gravity=false
		#
		pass
