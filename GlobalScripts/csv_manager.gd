extends Node2D
const ENEMY_DATA_PATH = "res://resources/enemy_data.csv"
const ENEMY_PROJECTILE_DATA_PATH="res://resources/enemy_projectile_data.csv"
const ENEMY_DATA_FAKE ="res://resources/enemy_data_fake.csv"
var cache = {}  # Store loaded CSVs in memory

# Instead of pretending enum → make a dropdown of named options
#@export_enum("ENEMY_DATA", "ENEMY_DATA_FAKE") var csv_choice: String = "ENEMY_DATA"

# Dictionary mapping "enum-like" strings to actual paths
@export var csv_paths = {
	"ENEMY_DATA": "res://resources/enemy_data.csv",
	"ENEMY_DATA_FAKE": "res://resources/enemy_data_fake.csv"
}

func _ready() -> void:
	#var path = csv_paths.get(csv_choice, "res://resources/enemy_data.csv")
	load_csv(ENEMY_DATA_PATH)
	load_csv(ENEMY_PROJECTILE_DATA_PATH)
	print(get_data("shield_riot", "health", ENEMY_DATA_PATH))
	
func _process(_delta):
	if Input.is_action_just_pressed("refresh_csv_cache"):
		reload_csv(ENEMY_DATA_PATH)
		reload_csv(ENEMY_PROJECTILE_DATA_PATH)
		print(name,":reloaded cache")


func load_csv(path: String) -> Array:
	if cache.has(path):
		return cache[path]

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Could not open file: " + path)
		return []

	var lines = file.get_as_text().split("\n", false)
	if lines.size() < 2:
		return []

	var headers = lines[0].split(",")
	var data: Array = []

	for i in range(1, lines.size()):
		if lines[i].strip_edges() == "":
			continue
		var values = lines[i].split(",")
		var row = {}
		for j in range(min(headers.size(), values.size())):
			row[headers[j].strip_edges()] = values[j].strip_edges()
		data.append(row)

	cache[path] = data
	return data


func reload_csv(path: String) -> Array:
	if cache.has(path):
		cache.erase(path)
	return load_csv(path)


# Get specific value by enemy name + column
func get_data(enemy_name: String, column: String, path: String):
	if not cache.has(path):
		push_error("CSV not loaded yet: " + path)
		return null

	for row in cache[path]:  # row is a Dictionary
		if row.has("name") and row["name"] == enemy_name:
			if row.has(column):
				return float(row[column])
			else:
				push_error("Column not found: " + column)
				return null

	push_error("Enemy not found: " + enemy_name)
	return null

func get_data_dictionary(enemy_name: String, path: String):
	if not cache.has(path):
		push_error("CSV not loaded yet: " + path)
		return {}

	for row in cache[path]:  # row is a Dictionary
		if row.has("name") and row["name"] == enemy_name:
			return row
		#else:
			#push_error("Row not found: " + var_to_str(row)+"for:"+enemy_name)
			#return {}

	push_error("Enemy not found: " + enemy_name)
	return {}
	
func get_enemy_data(enemy_name:String,path=ENEMY_DATA_PATH):
	if !enemy_name:
		print(name,":get_enemy_data:name/data missing")
		return
	return get_data_dictionary(enemy_name,path)
	
