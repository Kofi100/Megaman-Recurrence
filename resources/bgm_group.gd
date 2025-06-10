extends AudioStreamPlayer
class_name  BGM

# Called when the node enters the scene tree for the first time.
func _ready():
	#code written here to prevent large bursts of sound
	#when it starts playing before adjusting
	volume_db=OptionsSet.data["volumeSound"]["BGM"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	volume_db=OptionsSet.data["volumeSound"]["BGM"]
	if GlobalScript.health<=0:
		stop()
