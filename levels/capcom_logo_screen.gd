extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$showTimer.start()
	$Label.visible=false
	get_tree().create_tween().tween_property($AnimatedSprite2D,"modulate",Color.WHITE,1).from(Color.BLACK)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		moveToNextScreen()


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("default")
	$Label.visible=true


func _on_animated_sprite_2d_animation_finished() -> void:
	$hideTimer.start()

func moveToNextScreen():
	get_tree().change_scene_to_file("res://levels/beginning_scene.tscn")

func _on_hide_timer_timeout() -> void:
	var tween=create_tween();var tween2=create_tween()
	tween.tween_property($AnimatedSprite2D,"modulate",Color.BLACK,1).from(Color.WHITE)
	tween2.tween_property($Label,"modulate",Color.BLACK,1).from(Color.WHITE)
	tween.connect("finished",moveToNextScreen)
