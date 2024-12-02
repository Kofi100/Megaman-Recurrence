extends State
@export var freom:CharacterBody2D
func Enter():
	pass
func Exit():
	pass
	

func Physics_Update(delta):
	if freom:
		pass
		var distance=GlobalScript.playerposx-freom.global_position.x
		#print(freom.distance_player)
		if distance:
			if distance<0:
				freom.velocity.x=randi_range(-3000,-5000)*delta
			elif distance>=0:
				freom.velocity.x=randi_range(3000,5000)*delta
		freom.move_and_slide()
