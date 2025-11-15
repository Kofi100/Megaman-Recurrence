@tool
extends Node
#
#const enemy_type = {
	#NEW_SHOTMAN = "new_shotman",
	#MECHAKKERO = "mechakkero",
	#PETERCHY = "peterchy",
	#WALKING_BOMB = "walking_bomb",
	#MET = "met",
	#SNIPER_JOE = "sniper_joe",
	#OCTOPUS_BATTERY = "octopus_battery",
	#HOLOGRAN = "hologran",
	#HOMER = "homer",
	#PARAYSU = "paraysu",
	#PICKELMAN_BULL = "pickelman_bull",
	#YAMBOU = "yambou",
	#SPIKYOALL = "spikyoall",
	#CEILING_SHOOTER = "ceiling_shooter",
	#TACKLEFIRE = "tacklefire",
	#UPNDOWN = "upndown",
	#ENEMY_2 = "enemy_2",
	#BUSTER = "buster",
	#COUNT_BOMB = "count_bomb",
	#GRENADE_MAN = "grenade_man",
	#BURNER_JOE = "burner_joe",
	#SCREW_BOMBER = "screw_bomber",
	#ICE_TELLY = "ice_telly",
	#BOMBOMB = "bombomb",
	#ICE_JOE = "ice_joe",
	#RETURNINGMACHINE_JOE = "returningmachine_joe",
	#PUNK_RIOT = "punk_riot",
	#SHIELD_RIOT = "shield_riot",
	#DYNA_RIOT = "dyna_riot",
	#BATALLION_BALLOON = "batallion_balloon",
	#BATALLION_BALLOON_DELIVERY = "batallion_balloon_delivery",
	#KOPTAR = "koptar",
	#WOOLEEP = "wooleep",
	#SLEEPY_HARPER = "sleepy_harper",
	#FLOOR_SWEEPER = "floor_sweeper",
	#QUAD_CANNON = "quad_cannon",
	#CRIBLER = "cribler",
	#HEAVY_BRAWLER = "heavy_brawler"
#}


# Entity Post-Import Template for LDTK-Importer.
# Runs after LDtkImporter generates entity layers.
var print_data:bool=true
func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	var entities: Array = entity_layer.entities
	print("✅ Entity post-import running on layer:", entity_layer.name, "| Total entities:", entities.size())

	for entity in entities:
		if entity.identifier == "Enemy_spawner":
			# Load your enemy spawner scene
			var EnemySpawnerScene := preload("res://levels/spawners/enemy_spawner.tscn")
			var enemy_spawner = EnemySpawnerScene.instantiate()

			# Position it using the entity's LDtk coordinates
			enemy_spawner.position = Vector2(entity.position.x, entity.position.y)

			# If your LDtk entity has a field "enemy_names"
			if "enemy_names" in entity.fields:
				var split_name=str(entity.fields.enemy_names).split(".")[1]
				enemy_spawner.enemy_to_spawn = split_name

			# Add the spawner to the entity layer
			entity_layer.add_child(enemy_spawner)

			# Optional: link the LDtk entity IID for internal references
			if Engine.has_singleton("LDTKUtil"):
				var Util = Engine.get_singleton("LDTKUtil")
				if Util.has_method("update_instance_reference"):
					Util.update_instance_reference(entity.iid, enemy_spawner)
			if print_data:
				print("Spawner created for:", enemy_spawner.enemy_to_spawn, " at", enemy_spawner.position)

	return entity_layer

#func enum_to_str(value:):
	##return EnemyToSpawn_Copy.keys()[]
	#pass
