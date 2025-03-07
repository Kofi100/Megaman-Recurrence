extends enemy

# Set up variables
var speed = 50  # Horizontal speed of the projectile
var wave_amplitude = 2  # Amplitude of the wave (how high and low the wave goes)
var wave_frequency = 5  # How many waves per second
var direction = Vector2(1, 0)  # Direction of the projectile (moving right in this case)
var time = 0  # Used to track the wave oscillation over time


# Called every frame
func _physics_process(delta: float) -> void:
	playerdamagevalue = 5
	# Move the projectile forward with wave motion
	time += delta
	var wave_offset = wave_amplitude * sin(wave_frequency * time)  # Calculate wave offset
	position += direction * speed * delta  # Move horizontally
	position.y -= wave_offset  # Add the wave effect to the vertical position
