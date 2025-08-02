extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for node in $abilities_grid.get_children(true):
		for i in 12:
			if node==$abilities_grid.get_child(i):
				if MegamanAndItems.weaponNumberEnabled[i]==false:
					node.visible=false
				#continue
			
