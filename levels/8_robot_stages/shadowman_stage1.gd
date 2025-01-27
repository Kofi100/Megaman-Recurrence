extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.set_stage_name("Military\n Base")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bgm_shadow_man_finished():
	$BGM_ShadowMan.play()
