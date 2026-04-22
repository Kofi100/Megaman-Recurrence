#@tool
extends Node2D
var charge_timer = 0
@export var colorPalette:ColorPaletteResource
@export var resetColors:bool=false
#stuff we need to add to the save files
#bosses defeated=>weapons enabled
@export var weaponNumberEnabled={
	0:true,
	1:true,
	2:false,
	3:false,
	4:false,
	5:true,
	6:true,
	7:true,
	8:false,
	9:true,
	10:true,
	11:false
}
@export var weaponNumberEnabled_Template={
	0:false,
	1:false,
	2:false,
	3:false,
	4:false,
	5:false,
	6:false,
	7:false,
	8:false,
	9:false,
	10:false,
	11:false
}
var file_exists:bool=false
#intro Stage completed
@export var introStageComplete:bool=false
@export var introStageComplete_Template:bool=false


@export var weaponEnergy={
	0:27,
	1:27,
	2:27,
	3:27,
	4:27,
	5:27,
	6:27,
	7:27,
	8:27,
	9:27,
	10:27,
	11:27
}
@export var weaponEnergyCost={
	0:0,
	1:0,
	2:0,
	3:0,
	4:0,
	5:0,
	6:0,
	7:0,
	8:0,
	9:0,
	10:0,
	11:0
}
#Deleted BodyColor1 and 2 since they cannot accept ColorPaletteGlobalValues
#Might be painful but needed to keep code clean
#@export var C:Vector2=[ColorPaletteGlobal.LAVENDER,ColorPaletteGlobal.GREY]
#@export var colors: Dictionary = {
	#"LIGHT_VIOLET": Vector4(135.0, 0.0, 142.0, 255.0),
	#"BLACK": Vector4(0, 0, 0, 255),
	#"WHITE": Vector4(255, 255, 255, 255),
	#"LIGHTER_VIOLET": Vector4(251.0, 179.0, 255.0, 255.0),
	#"LIGHT_BLUE": Vector4(136.0, 232.0, 255.0, 255.0),
	#"DEEP_BLUE": Vector4(0.0, 98.0, 247.0, 255.0),
	#"DEEP_RED":Vector4(168.0,0.0,32.0,255.0),
	#"SLIGHTLY_DEEP_RED":Vector4(228.0,0.0,88.0,255.0),
	#"LIGHTER_DEEP_RED":Vector4(248.0,88.0,152.0,255.0),
	#
#}
#var weapon1energy = 27
#var weapon2energy = 27
#var weapon3energy = 27
var charge_buster_times = [0, 30, 105]
var Vector4255:Vector4i=Vector4i(255.0,255.0,255.0,255.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.
	loadData(GlobalScript.SAVEFILE_PATHS[0])

func _init() -> void:
	pass
	#cant place loaddate() since it might lead to errors during intialization

func check_whyyyyyyy_game_lags_when_left_for_sometime():
	#print(weaponNumberEnabled)
	var last_added_child
	if get_tree().current_scene:
		last_added_child=get_tree().current_scene.get_child(get_tree().current_scene.get_child_count()-1)
	var child_parent=last_added_child.get_parent()
	#print(get_tree().get_node_count())
	print([last_added_child,child_parent,get_tree().get_node_count()])
	var timer_count = count_nodes_of_type(get_tree().get_root(), "Timer")
	#print("Timers in scene:", timer_count)
	
	#print_debug([last_added_child,child_parent,get_tree().get_node_count()])
	#print(timer_count)
	#print_debug(timer_count)
	print(get_tree().get_node_count())
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):

	
	
	if resetColors==true:
		#colors=colors
		if Engine.is_editor_hint():
			queue_redraw()
	for keyValue in weaponEnergy:
		if weaponEnergy[keyValue]<=0:
			weaponEnergy[keyValue]=0
	#ColorPalette.
	#print(bodycolor1dictionary[1])
	#print(ColorPaletteGlobal.GREY)
var charge_confirm = false

## In your autoload script (e.g., GlobalPalette.gd)
#var color_palette: ColorPalette

func reload_palette():
	#colorPalette=load("res://GlobalScripts/colorPalette.gd")
	pass
func charge_effect(animated_sprite: AnimatedSprite2D):
	#ColorPaletteGlobal.colorDictionary.
	#colorPalette.
	if charge_timer == charge_buster_times[0]:
		charge_confirm = false
		animated_sprite.material.set_shader_parameter("outlinecolor", colorPalette.BLACK / 255)
		animated_sprite.material.set_shader_parameter("bodycolori", colorPalette.LIGHT_BLUE / 255)
		animated_sprite.material.set_shader_parameter("bodycolorii", colorPalette.DEEP_BLUE / 255)
	elif charge_timer >= charge_buster_times[1] and charge_timer < charge_buster_times[2]:  #30
		if not charge_confirm:
			charge_confirm = true
			#GlobalLogger.info(name,"Charge visuals initiated")
			#print("Charge visuals initiated")
		if charge_timer % 14 == 1:
			animated_sprite.material.set_shader_parameter("outlinecolor", (colorPalette.DEEP_RED) / 255.0)
		elif charge_timer % 14 == 5:
			animated_sprite.material.set_shader_parameter("outlinecolor", (colorPalette.SLIGHTLY_DEEP_RED) / 255.0)
		elif charge_timer%14==9:
			animated_sprite.material.set_shader_parameter("outlinecolor", (colorPalette.LIGHTER_DEEP_RED) / 255.0)
	elif charge_timer >= charge_buster_times[2]:
		if charge_timer % 14 == 1:
			animated_sprite.material.set_shader_parameter("outlinecolor", colorPalette.DEEP_BLUE / 255)
			animated_sprite.material.set_shader_parameter("bodycolori", colorPalette.BLACK / 255)
			animated_sprite.material.set_shader_parameter("bodycolorii", colorPalette.LIGHT_BLUE / 255)
		elif charge_timer % 14 == 5:
			animated_sprite.material.set_shader_parameter("outlinecolor", colorPalette.LIGHT_BLUE/ 255)#(Vector4(0.0, 98.0, 247.0, 255.0))
			animated_sprite.material.set_shader_parameter("bodycolori", colorPalette.DEEP_BLUE / 255)#(Vector4(136.0, 232.0, 255.0, 255.0))
			animated_sprite.material.set_shader_parameter("bodycolorii", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)

		elif charge_timer % 14 == 9:
			animated_sprite.material.set_shader_parameter("outlinecolor",  colorPalette.LIGHT_BLUE/ 255)
			animated_sprite.material.set_shader_parameter("bodycolori", colorPalette.DEEP_BLUE / 255)
			animated_sprite.material.set_shader_parameter("bodycolorii", Vector4(188,188,188,255) / 255)


func change_palette(node):
	if node is AnimatedSprite2D or node is TextureProgressBar:
		if weaponNumberEnabled.has(GlobalScript.weapon_number) and weaponNumberEnabled[GlobalScript.weapon_number]==true:
			match GlobalScript.weapon_number:
				1:
					set_Individual_Colors(node,colorPalette.CREAM,colorPalette.DARK_CREAM)
				5:
					set_Individual_Colors(node,colorPalette.OLIVE,colorPalette.DEEP_OLIVE)
				6:set_Individual_Colors(node,colorPalette.LIGHT_VIOLET,colorPalette.VIOLET)
				7:set_Individual_Colors(node,colorPalette.LAVENDER,colorPalette.DEEPER_LAVENDER)
				9:set_Individual_Colors(node,colorPalette.WHITE,colorPalette.DEEP_RED)
				10:set_Individual_Colors(node,colorPalette.WHITE,colorPalette.DEEP_RED)
func set_Individual_Colors(node,InnerBodyColor:Color,OuterBodyColor:Color):
	node.material.set_shader_parameter("outlinecolor", (Vector4(0.0, 0.0, 0.0, 255.0)) / 255)
	node.material.set_shader_parameter("bodycolori", InnerBodyColor)
	node.material.set_shader_parameter("bodycolorii", OuterBodyColor)

func saveWeaponState():
	pass

func saveData(file_path: String) -> bool:
	# Create directory if it doesn't exist
	var dir_path = file_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file for writing: %s. Error: %s" % 
		[file_path, FileAccess.get_open_error()])
		
		GlobalLogger.warn(name,
		"Failed to open file for writing: %s. Error: %s" %
		[file_path, FileAccess.get_open_error()])
		
		return false
	
	# Create a versioned save dictionary
	var save_data = {
		"version": 1,
		"intro_stage_complete": introStageComplete, #if file_exists else introStageComplete_Template,
		"weapons_enabled": weaponNumberEnabled, #if file_exists else weaponNumberEnabled_Template,#weaponNumberEnabled
		#"weapon_energy": weaponEnergy,
		"timestamp": Time.get_datetime_string_from_system()
	}
	
	file.store_var(save_data)
	file.close()
	
	GlobalLogger.info(name,"Successfully saved data to:%s " % file_path)
	return true

func loadData(file_path: String) -> bool:
	if not FileAccess.file_exists(file_path):
		GlobalLogger.warn(name,"Save file doesn't exist, creating new: %s " % file_path)
		file_exists = false
		return saveData(file_path)  # Create new save file
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file for reading: %s. Error: %s" % [file_path, FileAccess.get_open_error()])
		
		GlobalLogger.warn(name,
		"Failed to open file for reading: %s. Error: %s" % 
		[file_path, FileAccess.get_open_error()])
		
		return false
	
	var save_data = file.get_var()
	file.close()
	
	if not save_data is Dictionary:
		push_error("Invalid save data format in file: ", file_path)
		GlobalLogger.warn(name,"Invalid save data format in file:%s "% file_path)
		return false
	
	# Validate and load data with fallbacks
	introStageComplete = save_data.get("intro_stage_complete", introStageComplete_Template)
	weaponNumberEnabled = save_data.get("weapons_enabled", weaponNumberEnabled_Template)#weaponNumberEnabled
	#weaponEnergy = save_data.get("weapon_energy", weaponEnergy.duplicate())  # Keep current if not found
	
	file_exists = true
	GlobalLogger.info(name,"Successfully loaded data from: %s"% file_path)
	return true


func count_nodes_of_type(node: Node, type_name: String) -> int:
	var count = 0
	if node.get_class() == type_name:
		count += 1

	for child in node.get_children():
		count += count_nodes_of_type(child, type_name)
	
	return count
