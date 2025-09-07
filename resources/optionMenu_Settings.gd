extends Node2D

@export var volumeSound:Dictionary = {
	"BGM": -10,
	"SFX": 0
}
var current_version: float = 1.0

# Default settings
var default_data: Dictionary = {
	"volumeSound": {
		"BGM": -10,
		"SFX": 0
	},
	"resolution": 3,
	"max_lives": 3,
	"buster_rapid_shot":false,
	"fullscreen":false,
	"version": current_version
}

var data: Dictionary = default_data.duplicate(true)

const SAVE_SETTING_PATH := "user://options.txt"

func saveSettings() -> void:
	var file = FileAccess.open(SAVE_SETTING_PATH, FileAccess.WRITE)
	if file:
		var json = JSON.stringify(data)
		file.store_line(json)
		file.close()
		print("optionsGlobal: Saved Data..")

func loadSettings() -> void:
	if not FileAccess.file_exists(SAVE_SETTING_PATH):
		push_warning("optionsGlobal: No settings file, saving defaults..")
		saveSettings()
		return
	
	var save = FileAccess.open(SAVE_SETTING_PATH, FileAccess.READ)
	if not save:
		return
	
	var jsonvalues = save.get_as_text()
	var loaded_data = JSON.parse_string(jsonvalues)
	save.close()
	
	if typeof(loaded_data) != TYPE_DICTIONARY:
		push_warning("optionsGlobal: Invalid save file, resetting..")
		saveSettings()
		return
	
	# Merge loaded data with defaults
	for key in default_data.keys():
		if loaded_data.has(key):
			data[key] = loaded_data[key]
		else:
			data[key] = default_data[key]
	
	# Check version mismatch
	if not loaded_data.has("version") or loaded_data["version"] != current_version:
		push_warning("optionsGlobal: Version mismatch, updating settings..")
		data["version"] = current_version
		saveSettings()
	else:
		print("optionsGlobal: Loaded Data -> ", data)

func _init():
	loadSettings()
	print(name, " optionsGlobal: Initializing.. Loading Data...")
