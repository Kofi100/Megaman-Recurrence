#extends Resource
extends Node2D
#class_name OptionMenuSettings
@export var volumeSound:Dictionary={
	"BGM":-10,"SFX":0
}
var data={
	"volumeSound":{
		"BGM":-10,"SFX":0
	}
}
const SAVE_SETTING_PATH="res://options.txt"


func saveSettings():
	var file
	#ResourceSaver.save(self,SAVE_SETTING_PATH)
	#if not FileAccess.file_exists(SAVE_SETTING_PATH):
	file=FileAccess.open(SAVE_SETTING_PATH,FileAccess.WRITE)
	var json=JSON.stringify(data)
	
	file.store_line(json)
	file.close()
	print("optionsGlobal:saved Data..")
func loadSettings():
	var save
	#if ResourceLoader.exists(SAVE_SETTING_PATH):
	#return load(SAVE_SETTING_PATH)
	if not FileAccess.file_exists(SAVE_SETTING_PATH):
		return
	save=FileAccess.open(SAVE_SETTING_PATH,FileAccess.READ)
#gets values in file as text
	var jsonvalues=save.get_as_text()
#code changes string to a dictionary
	data=JSON.parse_string(jsonvalues)
	print(name," ",data)
	save.close()
func _init():
	loadSettings()
	print(name,"optionsGlobal:Initialiazing..Loading Data...")
