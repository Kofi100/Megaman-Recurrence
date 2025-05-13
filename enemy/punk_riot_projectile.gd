extends enemy

var miniState: int
var base_speed: float = 500  # Increased from 50 for better movement
var base_speedY:float=100
var bouncesLeft: int = 2
var gravity: float = 300  # Reduced gravity for more controlled bounces
var setDirection:bool=false
func _ready() -> void:
	pass
	#state="left"
	#miniState=1
	#setting initialDirection


func _physics_process(delta: float) -> void:
	playerdamagevalue = 2
	
	# Apply gravity
	#velocity.y += gravity * delta
	
	# Initialize velocity once to enable bounce to be effective
	if setDirection==false:
		match state:
			"left":
				#$Sprite2D.flip_h = false
				match miniState:
					1:
						velocity.x = -base_speed
						velocity.y = -base_speedY  # Consistent medium value
					2:
						velocity.x = -base_speed
						velocity.y = 0
					3:
						velocity.x = -base_speed
						velocity.y = base_speedY  # Matches the upward case
		
			"right":
				#$Sprite2D.flip_h = true
				match miniState:
					1:
						velocity.x = base_speed
						velocity.y = -base_speedY  # Same as left side
					2:
						velocity.x = base_speed
						velocity.y = 0
					3:
						velocity.x = base_speed
						velocity.y = base_speedY  # Same as left side
		setDirection=true
	#sets projectile to be facing current direction
	look_at(position*velocity)
	# Move and handle collision - multiply FINAL velocity by delta here
	var collision = move_and_collide(velocity * delta)
	if collision:
		handleBounce(collision)

func handleBounce(collision: KinematicCollision2D):
	if bouncesLeft <= 0:
		queue_free()
		return
	
	bouncesLeft -= 1
	
	# Get the bounce normal and reflect velocity
	var normal = collision.get_normal()
	velocity = velocity.bounce(normal)
	
	# Add energy loss (0.8 = keeps 80% of velocity)
	velocity *= 0.8
	
	# Debugging help:
	#print("Bounce! Remaining: ", bouncesLeft)
	#print("New Velocity: ", velocity)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
