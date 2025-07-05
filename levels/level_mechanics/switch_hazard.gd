extends enemy
var isOn:bool=true
var color
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	playerdamagevalue=5
	
	if isOn:
		$Area2D/CollisionShape2D.disabled=true
		$ColorRect.color=Color($ColorRect.color,0.5)
		
	else:
		$Area2D/CollisionShape2D.disabled=false
		$ColorRect.color=Color($ColorRect.color,1.0)
