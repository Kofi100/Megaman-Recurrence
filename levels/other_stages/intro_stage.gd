extends Node2D
var originalWeaponEnabledDict:Dictionary
func _ready() -> void:
	#checks originalWeaponEnabledDict and weaponNumberEnabled dictionaries
	#before copying operation to originalWeaponEnabledDict
	#print("_ready:before:OWEn:",originalWeaponEnabledDict)
	#print("_ready:before:MaI.wNE:",MegamanAndItems.weaponNumberEnabled)
	originalWeaponEnabledDict=MegamanAndItems.weaponNumberEnabled.duplicate(true)
	#originalWeaponEnabledDict=JSON.parse_string(JSON.stringify(MegamanAndItems.weaponNumberEnabled)).result
	#disable all RM weapons upon entering intro stage
	
	for i in 9:#randi_range(12):
		if i!=0 :
			MegamanAndItems.weaponNumberEnabled[i]=false
			print(i)
	MegamanAndItems.weaponNumberEnabled[0]=true
	#checks originalWeaponEnabledDict and weaponNumberEnabled dictionaries
	#after copying operation
	#print("_ready:after:OWEn:",originalWeaponEnabledDict)
	#print("_ready:after:MaI.wNE:",MegamanAndItems.weaponNumberEnabled)
func _physics_process(delta: float) -> void:
	$GPUParticles2D.global_position.x=$megaman/player_camera.global_position.x+250#Vector2(250,0)

func _exit_tree() -> void:
	pass


func _on_tree_exiting() -> void:
	print(name,":about to exit tree")
	MegamanAndItems.weaponNumberEnabled=originalWeaponEnabledDict
	print(originalWeaponEnabledDict)
	print(MegamanAndItems.weaponNumberEnabled)
