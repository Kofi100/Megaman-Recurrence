@tool

#@icon("res://addons/new_camera_system/assets/new camera system icon.png")
#class_name Camera_System_PlugIn

extends Area2D
##Player's Camera.Is found automatically using code when a player enters this area in the game.
var player_camera: Camera2D
##Camera2D node that is used by the node to set camera zones in the game.
@export var zone_camera_2d: Camera2D
##CollisionShape2D node that sets the Zone Camera's limits. Is found automatically.
@export var collision_limits_camera: CollisionShape2D
##GlobalTimerchecker which checks if you've declared a GlobalScreenTransitionTimer in your game as a global variable.
@export var GlobalTimerChecker: Timer
##A float variable which is used to set up how often this node updates itself esp.its settings.
@export var timer_exists: bool
var time_offset: float = 0
##Camera Limit on the left set by the CollisionShape2D.
var limit_l = 0
##Camera Limit on the right set by the CollisionShape2D.
var limit_r = 0
##Camera Limit on the top set by the CollisionShape2D.
var limit_u = 0
##Camera Limit on the bottom set by the CollisionShape2D.
var limit_d = 0
@export var no_back_track_area: StaticBody2D
@export var no_back_tracking: bool = false
@export_enum("NONE", "LEFT", "RIGHT") var player_transition_direction_x: String="NONE"
@export_enum("NONE", "UP", "DOWN") var player_transition_direction_y: String="NONE"
@export var allowed_transition_movement:Dictionary={
	"left":true,"right":true,"up":true,"down":true
}
@export var universal_canvas_modulate:CanvasModulate
@export var is_darkness_area:bool=false

var camera
var cached_last_shape: Shape2D #For lightweight 

# Called when the node enters the scene tree for the first time.
## A custom made Area2D node that handles camera movement and limits using a Camera2D node and a CollisionShape2D node. Requires a GlobalTransitionTimer to work.

func _ready():
	pass  # Replace with function body.
	collision_limits_camera = get_node_or_null("CollisionShape2D")
	#zone_camera_2d = get_node_or_null("Camera2D")  #%Camera2D
	if zone_camera_2d==null:
		camera = Camera2D.new()
		add_child(camera)
		zone_camera_2d = camera
	
	if not area_entered.is_connected(_on_area_entered):
		connect("area_entered", _on_area_entered)
	
	if collision_limits_camera and collision_limits_camera.shape:#.get_rect().size!=Vector2.ZERO:
		#if not collision_limits_camera.shape.changed.is_connected(update_camera_limits):
		collision_limits_camera.shape.changed.connect(update_camera_limits)
		update_camera_limits()

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _enter_tree():
	pass
	if GlobalTimerChecker == null:
		timer_exists = false
		GlobalTimerChecker = GlobalScreenTransitionTimer  #get_tree().current_scene.get_node_or_null("Transition_Timer")#GlobalScreenTransitionTimer
	else:
		timer_exists = true


func _process(delta):
	if collision_limits_camera == null:
		collision_limits_camera = get_node_or_null("CollisionShape2D")
		return
	if zone_camera_2d==null:
		zone_camera_2d=get_node_or_null("Camera2D")
		return
	#if collision_limits_camera and collision_limits_camera.shape:
		#if not collision_limits_camera.shape.changed.is_connected(update_cam	era_limits):
			#collision_limits_camera.shape.changed.connect(update_camera_limits)
			#
	var shape = collision_limits_camera.shape
	# Shape was added OR changed OR replaced
	if shape != cached_last_shape:
		# disconnect previous shape
		if cached_last_shape and cached_last_shape.changed.is_connected(update_camera_limits):
			cached_last_shape.changed.disconnect(update_camera_limits)

		# connect new shape
		if shape and not shape.changed.is_connected(update_camera_limits):
			shape.changed.connect(update_camera_limits)

		cached_last_shape = shape
	#if collision_limits_camera != null:
		

	#if no_back_track_area == null:
		#no_back_track_area = get_node_or_null("StaticBody2D")

	if no_back_track_area:
		if not Engine.is_editor_hint():
			if no_back_tracking == true:
				if GlobalScript.playerposx > zone_camera_2d.limit_right:
					if GlobalScreenTransitionTimer.is_stopped():
						no_back_track_area.set_collision_layer_value(1, true)
				else:
					no_back_track_area.set_collision_layer_value(1, false)
			else:
				no_back_track_area.set_collision_layer_value(1, false)

func update_camera_limits():
	if collision_limits_camera.shape.get_rect().size==Vector2.ZERO:
		return
	#print("Update camera limits:Active")
	var pos_x = collision_limits_camera.global_position.x
	var pos_y = collision_limits_camera.global_position.y
	var size_l = collision_limits_camera.shape.get_rect().size.x
	var size_h = collision_limits_camera.shape.get_rect().size.y
	limit_l = pos_x - (size_l / 2)
	limit_r = pos_x + (size_l / 2)
	limit_u = pos_y - (size_h / 2)
	limit_d = pos_y + (size_h / 2)
	#zone_camera_2d.limit_left=limit_l
	if zone_camera_2d != null:
		
		#zone_camera_2d.set("limit_left", limit_l)#slower than setting the limits directly.
		#zone_camera_2d.set("limit_right", limit_r)
		zone_camera_2d.limit_left=limit_l
		zone_camera_2d.limit_right=limit_r
		zone_camera_2d.limit_top = limit_u
		zone_camera_2d.limit_bottom = limit_d
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		#print("cchnaged")
		pass

func _on_area_entered(area):
	if area.is_in_group("player_constants_checker_area2d"):  #and area.get_parent().player_ready==true
		var player = area.get_parent()
		player_camera = area.get_parent().get_node("player_camera")
		if "player_transition_direction_x" in player:
			player.player_transition_direction_x=player_transition_direction_x
		if "player_transition_direction_y" in player:
			player.player_transition_direction_y=player_transition_direction_y
		if "allowed_transition_movement" in player:
			player.allowed_transition_movement=allowed_transition_movement
			#print([player.allowed_transition_movement==allowed_transition_movement])
			#print(pl)
		#print(name, ": Player entered me.")
		#await get_tree().create_timer(.1).timeout
		if player_camera != null:
			#zone_camera_2d.set("zone_camera_2d.limit_right", limit_r)
			zone_camera_2d.limit_left=limit_l
			zone_camera_2d.limit_right = limit_r
			zone_camera_2d.limit_top = limit_u
			zone_camera_2d.limit_bottom = limit_d
			switch_camera(player_camera, zone_camera_2d)
			if GlobalTimerChecker != null and GlobalTimerChecker is Timer and GlobalTimerChecker.one_shot == true:
				GlobalTimerChecker.start()
#region old code
#decoding how to tie the cmaera's limits to the area collsionshape of the camera
		#if collision_limits_camera!=null:
		#player_camera.limit_left=
		#print(name,":get_rect().position.x->",collision_limits_camera.shape.get_rect().position.x)
		#
		#var pos_x=collision_limits_camera.global_position.x#abs(collision_limits_camera.shape.get_rect().position.x)
		#var pos_y=collision_limits_camera.global_position.y#abs(collision_limits_camera.shape.get_rect().position.y)
		#var size_l=collision_limits_camera.shape.get_rect().size.x
		#var size_h=collision_limits_camera.shape.get_rect().size.y
		#print(name,"get_Rect().width&pos_x->",size_l,"    ",pos_x," ",size_h," ",pos_y)
		#
		#print(name,"get_Rect().size.width->",collision_limits_camera.shape.get_rect().size.x)
		#print(name,"get_Rect().left_bondry->",pos_x-(size_l/2))
		#print(name,"get_Rect().right_bondry->",pos_x+(size_l/2))
		#print(name,"get_Rect().up_bondry->",pos_y-(size_h/2))
		#print(name,"get_Rect().down_bondry->",pos_y+(size_h/2))
#endregion
		elif player_camera == null:
			#print("player_camera:cannot be detected")
			push_error(name, ": player camera:cannot be found. No transition would occur.")


func switch_camera(main_camera: Camera2D, camera_to_switch: Camera2D):
	#print("New Camera System: Switching cam to :", name)
	main_camera.limit_left = camera_to_switch.limit_left
	main_camera.limit_right = camera_to_switch.limit_right
	main_camera.limit_top = camera_to_switch.limit_top
	main_camera.limit_bottom = camera_to_switch.limit_bottom
	if is_darkness_area: #and universal_canvas_modulate
		#var tween=create_tween()
		#tween.tween_property(universal_canvas_modulate,"color",Color.DIM_GRAY,1.0)
		GlobalScript.slumbshade_darkness_active=true

	elif not is_darkness_area: # and universal_canvas_modulate
		
		#if universal_canvas_modulate.color==Color.DIM_GRAY:
			#var tween=create_tween()
			#tween.tween_property(universal_canvas_modulate,"color",Color.WHITE,1.0)
			GlobalScript.slumbshade_darkness_active=false
