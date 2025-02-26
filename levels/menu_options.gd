extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$BGMSlider.value = OptionsSet.data["volumeSound"]["BGM"]
	$SFXSlider.value = OptionsSet.data["volumeSound"]["SFX"]
	$BGMSlider.connect("drag_ended", changeBGMVolume)  #(true)
	$SFXSlider.connect("drag_ended", changeSFXVolume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func changeBGMVolume(value_changed: bool):
	if value_changed:
		OptionsSet.data["volumeSound"]["BGM"] = $BGMSlider.value
		OptionsSet.saveSettings()


func changeSFXVolume(value_changed: bool):
	if value_changed:
		OptionsSet.data["volumeSound"]["SFX"] = $SFXSlider.value
		OptionsSet.saveSettings()


func _on_exit_pressed():
	self.queue_free()


func _on_bgm_slider_drag_ended(value_changed):
	pass  # Replace with function body.
