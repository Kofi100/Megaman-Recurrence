extends CharacterBody2D
var isOn=false
@export var color:Color=Color.GREEN
func _ready() -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	$CollisionShape2D.disabled=!isOn
	if isOn:
		$ColorRect.color=Color(color,1.0)
	else:
		$ColorRect.color=Color(color,0.5)
		
