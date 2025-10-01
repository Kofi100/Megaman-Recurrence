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
# Called when the node enters the scene tree for the first time.
## A custom made Area2D node that handles camera movement and limits using a Camera2D node and a CollisionShape2D node. Requires a GlobalTransitionTimer to work.


func _ready():
	pass  # Replace with function body.
	collision_limits_camera = get_node_or_null("CollisionShape2D")
	zone_camera_2d = get_node_or_null("Camera2D")  #%Camera2D
	#if zone_camera_2d==null:
	#var new_camera=Camera2D.new()
	#new_camera.name="New_camera"
	#set_editable_instance(new_camera,true)
	#add_child(new_camera)
	#zone_camera_2d=get_node_or_null(new_camera)
	#if collision_limits_camera==null:
	#var new_collision_Shape_2d=CollisionShape2D.new()
	#new_collision_Shape_2d.name="new_collision_Shape_2D_name"
	#add_child(new_collision_Shape_2d)
	#collision_limits_camera.get_node_or_null(new_collision_Shape_2d)
	#print(name,"(custom camera node)-->zone_camera_2d:::",zone_camera_2d)


# Called every frame. 'delta' is the elapsed time since the previous frame.


#func _enter_tree():
#pass
#
#func _exit_tree():
#pass
#@export var timer_exists:bool
func _process(delta):
#	set_editor_description("")

	#print(get_class())
	if not area_entered.is_connected(_on_area_entered):
		connect("area_entered", _on_area_entered)
	if zone_camera_2d == null:
		zone_camera_2d = get_node_or_null("Camera2D")
		#if no camera has been assigned yet,create a new local one
		#and add it to this node
		#also make zone_Camera_2d be this new camera2D node
		if zone_camera_2d == null:
			var camera = Camera2D.new()
			add_child(camera)
			camera.global_position = global_position
			zone_camera_2d = camera
	if collision_limits_camera == null:
		collision_limits_camera = get_node_or_null("CollisionShape2D")

	if GlobalTimerChecker == null:
		timer_exists = false
		GlobalTimerChecker = GlobalScreenTransitionTimer  #get_tree().current_scene.get_node_or_null("Transition_Timer")#GlobalScreenTransitionTimer
	else:
		timer_exists = true
	if is_inside_tree():
		#set_editable_instance(self,true)
		time_offset += 1 * delta
		#print(int(time_offset))
		#if fmod(time_offset,2)>0 and fmod(time_offset,2)<0.1:# int(time_offset)%2==1:#fmod(time_offset,1)==1:
		##push_warning("new camera system node: time_offset in operation")
		#
		#notify_property_list_changed() #updates inspector and editor
		if zone_camera_2d != null:
			zone_camera_2d.notify_property_list_changed()

	if collision_limits_camera != null:
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
			zone_camera_2d.set("limit_left", limit_l)
			zone_camera_2d.set("limit_right", limit_r)

			zone_camera_2d.limit_top = limit_u
			zone_camera_2d.limit_bottom = limit_d

	if no_back_track_area == null:
		no_back_track_area = get_node_or_null("StaticBody2D")

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
		print(name, ": Player entered me.")
		#await get_tree().create_timer(.1).timeout
		if player_camera != null:
			zone_camera_2d.set("zone_camera_2d.limit_right", limit_r)
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
	print("New Camera System: Switching cam to :", name)
	main_camera.limit_left = camera_to_switch.limit_left
	main_camera.limit_right = camera_to_switch.limit_right
	main_camera.limit_top = camera_to_switch.limit_top
	main_camera.limit_bottom = camera_to_switch.limit_bottom
