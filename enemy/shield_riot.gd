extends enemy

func _ready() -> void:
 playerdamagevalue=3

func _physics_process(delta: float) -> void:
 pass
 calculate_player_distance()
 if distance_x<0:
  $AnimatedSprite2D.flip_h=false
 elif distance_x>=0:
  $AnimatedSprite2D.flip_h=true
#print("hello")
