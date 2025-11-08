extends AudioStreamPlayer
class_name  BGM

# Called when the node enters the scene tree for the first time.
func _ready():
	#code written here to prevent large bursts of sound
	#when it starts playing before adjusting
	bus="BGM"
	#volume_db=-60
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"),-72)
	var saved_volume_options=OptionsSet.data["volumeSound"]["BGM"]
	if playing:
		#volume_db=-60
		stop()
		#await get_tree().create_timer(.2).timeout
		#volume_db=OptionsSet.data["volumeSound"]["BGM"]
		#using audioBus here
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"),linear_to_db(saved_volume_options))#linear_to_db(
		play()
		return
	#volume_db=OptionsSet.data["volumeSound"]["BGM"]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#volume_db
	var saved_volume_options=OptionsSet.data["volumeSound"]["BGM"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"),linear_to_db(saved_volume_options) )
	#volume_db=OptionsSet.data["volumeSound"]["BGM"]	
	if GlobalScript.health<=0:
		stop()
