extends AudioStreamPlayer
class_name SFX


# Called when the node enters the scene tree for the first time.
func _ready():
	bus="SFX"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#volume_db = OptionsSet.data["volumeSound"]["SFX"]
	var saved_volume_options=OptionsSet.data["volumeSound"]["SFX"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(saved_volume_options) )
	#print(saved_volume_options)
