extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var reverse_gravity_up:bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw() -> void:
	pass
	#var shape_size= collision_shape_2d.shape.get_rect().size
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	if area.is_in_group("player_constants_checker_area2d"):
		var body=area.get_parent()
		#code deactivated till i rearrange my code to easily play megaman's animations 
		#without being restricted to is_on_fllor or is_on_ceiling everytime
		#done with that thx to GOD and using a functions:
		#one for checking fllor condtions 
		#GlobalLogger.debug(name,"body.velocity.x:%s"%body.velocity.x)
		if reverse_gravity_up:
			#if body.velocity.x>0:
				body.reverse_gravity=true
			#if body.velocity.x<0:
				##GlobalLogger.info(name,"velocity.x<0")
				#body.reverse_gravity=false
		else:
			
			#if body.velocity.x>0:
				#GlobalLogger.info(name,"velocity.x<0")
				body.reverse_gravity=false
			#elif body.velocity.x<0:
				#body.reverse_gravity=true
