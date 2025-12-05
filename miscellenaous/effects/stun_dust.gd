extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index=0
	#Logger.debug(name,"spawned in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await animation_finished
	queue_free()
