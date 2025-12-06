extends Node2D
var originalWeaponEnabledDict: Dictionary
@onready var background_balloons_effect: CPUParticles2D = $Background/background_balloons_effect
@onready var player_camera:Camera2D=$Entities/Players/megaman/player_camera

func _ready() -> void:
	#checks originalWeaponEnabledDict and weaponNumberEnabled dictionaries
	#before copying operation to originalWeaponEnabledDict
	#print("_ready:before:OWEn:",originalWeaponEnabledDict)
	#print("_ready:before:MaI.wNE:",MegamanAndItems.weaponNumberEnabled)
	originalWeaponEnabledDict = MegamanAndItems.weaponNumberEnabled.duplicate(true)
	#originalWeaponEnabledDict=JSON.parse_string(JSON.stringify(MegamanAndItems.weaponNumberEnabled)).result
	#disable all RM weapons upon entering intro stage

	for i in 9:  #randi_range(12):
		if i != 0:
			MegamanAndItems.weaponNumberEnabled[i] = false
			#print(i)
	#disable Rush Utilities
	MegamanAndItems.weaponNumberEnabled[9] = false
	MegamanAndItems.weaponNumberEnabled[10] = false
	MegamanAndItems.weaponNumberEnabled[11] = false
	#re-enable Mega Buster if disabled
	MegamanAndItems.weaponNumberEnabled[0] = true
	background_balloons_effect.set("emitting",true)
	#checks originalWeaponEnabledDict and weaponNumberEnabled dictionaries
	#after copying operation
	#print("_ready:after:OWEn:",originalWeaponEnabledDict)
	#print("_ready:after:MaI.wNE:",MegamanAndItems.weaponNumberEnabled)


func _physics_process(_delta: float) -> void:
	background_balloons_effect.global_position.x = player_camera.global_position.x + 250  #Vector2(250,0)
	#$Parallax2D4.autoscroll.x = -48


func _exit_tree() -> void:
	#print(name, ":about to exit tree")
	GlobalLogger.info(name,"about to exit stage")
	MegamanAndItems.weaponNumberEnabled = originalWeaponEnabledDict
	#print(originalWeaponEnabledDict)
	#print(MegamanAndItems.weaponNumberEnabled)
	
	#logic here is that the original states of all wepaons 
	#are saved originalWeaponEnabledDict earlier
	# and are retrieved by MegamanAndItems.weaponNumberEnabled before the level exits.
	GlobalLogger.info(name,"check if all weapons are activated now: %s" % (originalWeaponEnabledDict==MegamanAndItems.weaponNumberEnabled))


func _on_tree_exiting() -> void:
	pass
