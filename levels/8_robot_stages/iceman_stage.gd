extends Node2D
var changeChance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	changeChance=randi_range(1,100)
	#print(changeChance)
	if changeChance<=50:
		$BGM2.play()
	else:
		$BGM.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bgm_finished() -> void:
	$BGM.play()
