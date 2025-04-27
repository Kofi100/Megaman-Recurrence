extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var fadeInTween=get_tree().create_tween()
	fadeInTween.tween_property($disclaimer,"modulate",Color.WHITE,1).from(Color.BLACK)
	fadeInTween.connect("finished",start_Timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"): #and not $switch_Screen_Timer.is_stopped():
		$switch_Screen_Timer.stop()
		transition_Scene()

func start_Timer():
	$switch_Screen_Timer.start()
func transition_Scene():
	get_tree().change_scene_to_file("res://levels/capcom_logo_screen.tscn")

func _on_switch_screen_timer_timeout() -> void:
	var fadeOutTween=get_tree().create_tween()
	fadeOutTween.tween_property($disclaimer,"modulate",Color.BLACK,1).from(Color.WHITE)
	fadeOutTween.connect("finished",transition_Scene)
