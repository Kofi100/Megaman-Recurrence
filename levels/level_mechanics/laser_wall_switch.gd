@tool
extends CharacterBody2D
@export_tool_button("Refresh Tracked Lasers") var track_switches_action=track_switches

@export var isOn:bool=true
@export var arrayOfLasers:Array[LaserWallMechanic]

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var time=0

func _physics_process(_delta: float) -> void:
	$switchOnTimer.wait_time=3
	#if isOn:
	if not Engine.is_editor_hint():
		for everyLaser in arrayOfLasers:
			if everyLaser!=null:
				everyLaser.isOn=isOn
				$ColorRect.color=Color.GREEN if isOn else Color.RED
	if  Engine.is_editor_hint():
		time+=1*_delta
		if fmod(time,10)==1:pass


	move_and_slide()

func _enter_tree() -> void:
	track_switches()

func track_switches():
	#print(name,":track switches() running"  )
	var array_of_lines:Array[Node2D]
	if array_of_lines.size()!=0:
		for line in array_of_lines:
			line.queue_free()
			print(is_instance_valid(line))
	if Engine.is_editor_hint():
		for everyLaser in arrayOfLasers:
			var line2d=Line2D.new()
			line2d.width=2
			line2d.default_color=Color.PURPLE
			#line2d.set_texture(preload("res://assets/sprites/miscelleaneous/link_laserswitches_editor.png"))
			#line2d.texture_mode=Line2D.LINE_TEXTURE_TILE
			get_parent().add_child.call_deferred(line2d)
			array_of_lines.append(everyLaser)
			line2d.add_point(global_position,0)
			line2d.add_point(everyLaser.global_position,1)
	
	#print(array_of_lines)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectiles"):
		if $switchOnTimer.is_stopped()==true:
			$switchOnTimer.start()
			
			isOn=false
		if area.get_parent().shouldBeDestroyedByLaserSwitch==true:
			area.get_parent().queue_free()


func _on_switch_on_timer_timeout() -> void:
	isOn=true
