extends enemy
@export var speed := 70.0
@export var shake_amplitude := 100.0   # how wide it wiggles
@export var shake_frequency := 10.0   # how fast it wiggles

var direction := Vector2.RIGHT
var time := 0.0

var noise := FastNoiseLite.new()

func _ready():
	noise.frequency = 5.0


func _physics_process(delta):
	playerdamagevalue=2
	time += delta
	
	
	var forward_velocity = direction * speed
	var perpendicular = Vector2(-direction.y, direction.x)
	
	var noise_value = noise.get_noise_1d(time)
	var shake_offset = perpendicular * noise_value * shake_amplitude
	
	velocity = forward_velocity + shake_offset
	if direction==Vector2.LEFT:
		$AnimatedSprite2D.flip_h=false
	elif direction==Vector2.RIGHT:
		$AnimatedSprite2D.flip_h=true
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
