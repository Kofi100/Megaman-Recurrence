@tool
extends Node2D

@export var node_to_add_to_enemy: Node2D
var new_node
@export_enum("new_shotman","mechakkero","peterchy","walking_bomb",
"met","sniper_joe","octopus_battery","hologran","homer","paraysu",
"pickelman_bull","yambou","spikyoall","ceiling_shooter","tacklefire",
"upndown","enemy_2","buster","count_bomb","grenade_man","burner_joe",
"screw_bomber","ice_telly","bombomb","ice_joe","returningmachine_joe",
"punk_riot","shield_riot","dyna_riot","batallion_balloon","batallion_balloon_delivery","koptar",
"wooleep","sleepy_harper","floor_sweeper","quad_cannon","cribler","heavy_brawler") var enemy_to_spawn: String = "" :
	#detect changes in enemy_to_spawn
	#to prevent overlapping old and new enemies
	set(value):
		value=value.to_lower()
		if enemy_to_spawn!=value:
			enemy_to_spawn=""
			enemy_to_spawn=value
			_on_enemy_changed()
#@export var spawn_index:int
#var new_shotman=preload("")
#var peterchy=preload("res://enemy/peterchy.tscn")
#var mechakkero=preload()
#var walking_bomb=preload('res://enemy/walking_bomb.tscn')
var new_enemy
@export var visibility = true:
	set(new_value):
		if Engine.is_editor_hint():
			visibility=new_value
			_update_disappear_nodes()
		else:
			visibility=false
			_update_disappear_nodes()
	
@export var visibility_enemy_display = false
#@export
var enemy_dictionary: Dictionary = {
	"new_shotman": preload("res://enemy/new_shotman.tscn"),
	"mechakkero": preload("res://enemy/mechakkero.tscn"),
	"peterchy": preload("res://enemy/peterchy.tscn"),
	"walking_bomb": preload("res://enemy/walking_bomb.tscn"),
	"met": preload("res://enemy/met.tscn"),
	"sniper_joe": preload("res://enemy/sniper_joe.tscn"),
	"octopus_battery": preload("res://enemy/octopus_battery.tscn"),
	"hologran": preload("res://enemy/hologran.tscn"),
	"homer": preload("res://enemy/original/homer.tscn"),
	"paraysu": preload("res://enemy/paraysu.tscn"),
	"pickelman_bull": preload("res://enemy/pickelman_bull.tscn"),
	"yambou": preload("res://enemy/yambou.tscn"),
	"spikyoall": preload("res://enemy/original/spikyoall.tscn"),
	"ceiling_shooter": preload("res://enemy/original/ceiling_shooter.tscn"),
	"tacklefire": preload("res://assets/sprites/enemies/tacklefire.tscn"),
	"upndown": preload("res://enemy/upndown.tscn"),
	"enemy_2": preload("res://enemy/original/enemy_2.tscn"),
	"buster": preload("res://enemy/original/buster.tscn"),
	"count_bomb": preload("res://enemy/count_bomb.tscn"),
	"grenade_man": preload("res://enemy/original/grenade_man.tscn"),
	"burner_joe": preload("res://enemy/original/sniper_joe_variant_fire.tscn"),
	"screw_bomber": preload("res://enemy/screw_bomber.tscn"),
	"ice_telly":preload("res://enemy/original/ice_telly.tscn"),
	"bombomb":preload("res://enemy/bombomb.tscn"),
	"ice_joe":preload("res://enemy/original/ice_joe.tscn"),
	"returningmachine_joe":preload("res://enemy/returning_machine_joe.tscn"),
	"punk_riot":preload("res://enemy/punk_riot.tscn"),
	"shield_riot":preload("res://enemy/shield_riot.tscn"),
	"dyna_riot":preload("res://enemy/dyna_riot.tscn"),
	"batallion_balloon":preload("res://enemy/batallion_balloon.tscn"),
	"batallion_balloon_delivery":preload("res://enemy/batallion_balloon_delivery.tscn"),
	"koptar":preload("res://enemy/koptar.tscn"),
	"wooleep":preload("res://enemy/wooleep.tscn"),
	"sleepy_harper":preload("res://enemy/sleepy_harper.tscn"),
	"floor_sweeper":preload("res://enemy/floor_sweeper.tscn"),
	"quad_cannon":preload("res://enemy/quad_cannon.tscn"),
	"cribler":preload("res://enemy/cribler.tscn"),
	"heavy_brawler":preload("res://enemy/heavy_brawler.tscn")
}
#@export

var disappear_nodes = {
	1: "Sprite2D",
	2: "index",
	3: "enemy",
	#4: "enemy_spawn_list",
}
@export_enum("none", "fire", "ice") var enemyVariant: String = "none"
@export var SetinitialDirection:String
@export var InitialDirection_Mini:String
@export_enum("shield_riot","dyna_riot") var riotToDeliver:String=""
var riot_Instance=null
# Called when the node enters the scene tree for the first time.
var spawn_timer: int = 0


func _ready():
	pass

#func _enter_tree() -> void:
	#

var spawn_homer = false
var has_enemy_spawned = false
var display_node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _enter_tree():
	request_ready()
	#notify_property_list_changed()

@export var enemy_Preview:CharacterBody2D
#func setEnemyName(value):
	#if enemy_to_spawn!=value:
		#enemy_to_spawn=""
		#enemy_to_spawn=value
#func _update_editor_preview():
	#pass
func _process(_delta):
	if not Engine.is_editor_hint():
		visibility=false
		#print(GlobalScreenTransitionTimer.time_left)
		display_node = get_node_or_null("enemy_display_sprite")


		#to be used later

	#	if GlobalScript.spawn_enemy:
	#		if $VisibleOnScreenNotifier2D.is_connected('screen_entered',_on_visible_on_screen_notifier_2d_screen_entered)==false:
	#			$VisibleOnScreenNotifier2D.connect('screen_entered',_on_visible_on_screen_notifier_2d_screen_entered)
	#	elif not GlobalScript.spawn_enemy:
	#		if $VisibleOnScreenNotifier2D.is_connected('screen_entered',_on_visible_on_screen_notifier_2d_screen_entered)==true:
	#			$VisibleOnScreenNotifier2D.disconnect('screen_entered',_on_visible_on_screen_notifier_2d_screen_entered)
		#displays enemies to be spawned
		#print('new'+enemy_to_spawn)
		#testing if new variables can be made..kinda
	#	var new='new_'+enemy_to_spawn

		$enemy.text = enemy_to_spawn
		if entered == true and GlobalScreenTransitionTimer.time_left <= 0:
			#timer+=1
	#		if new_enemy==null and enemy_to_spawn!='homer':
	#			has_enemy_spawned=false
	#		elif new_enemy==null and enemy_to_spawn=='homer':
	#			if
			#if timer==1:
			if not has_enemy_spawned and new_enemy == null:
				if enemy_dictionary.has(enemy_to_spawn):
					has_enemy_spawned = true
					var enemy_scene = enemy_dictionary.get(enemy_to_spawn)
					if enemy_to_spawn!="batallion_balloon_delivery":
						new_enemy = enemy_scene.instantiate()
					elif not is_instance_valid(riot_Instance):
						new_enemy = enemy_scene.instantiate()
					#checks for variants in enemies before changing to their variants
					if enemyVariant != "none":
						if "enemyVariant" in new_enemy:
							new_enemy.enemyVariant = enemyVariant
					if "InitialDirection" in new_enemy:
						new_enemy.InitialDirection=SetinitialDirection
						if "InitialDirection_Mini" in new_enemy:
							new_enemy.InitialDirection_Mini=InitialDirection_Mini
					#if node_to_add_to_enemy!=null:
					#new_node=node_to_add_to_enemy.duplicate()
					#if node_to_add_to_enemy!=null and new_node!=null:
					##new_node.parent
					#new_node.reparent(new_enemy)
					#new_enemy.add_child(new_node)

					#new_enemy.index=spawn_index
					new_enemy.position = position
					get_parent().add_child(new_enemy)
					#entered=false
					#print(name,'[enemy_spawner]:new_node_to_add:[new node]-> ',new_node)
			if (enemy_to_spawn == "homer" or enemy_to_spawn == "upndown" or enemy_to_spawn=="bombomb") and new_enemy == null and $spawn_homer_timer.time_left <= 0:
				$spawn_homer_timer.start()
			if enemy_to_spawn=="batallion_balloon_delivery" and is_instance_valid(enemy_to_spawn):
				new_enemy.riotToDeliver=riotToDeliver
				riot_Instance=new_enemy.enemyIns
			#if GlobalScreenTransitionTimer.is_stopped()==false:
				#if new_enemy:
					#new_enemy.queue_free()
				#print(name,":started respawn timer for upndown and homer")

		elif entered == false and new_enemy == null:
			#timer=0
			has_enemy_spawned = false
		if enemy_to_spawn == "tacklefire":
			spawn_timer += 1
			if spawn_timer % 30 == 1:
				has_enemy_spawned = false
	#region Previous code to stop enemies upon transitioning to new screen
		# previous code to stop enemies upon transitioning to new screen
		#if GlobalScreenTransitionTimer.time_left>0:
		##for i in get_tree().current_scene.get_children():
		##if i is enemy:
		##if new_enemy!=null:
		#if new_enemy!=null:
		#new_enemy.set_physics_process(false)
		#new_enemy.velocity=Vector2.ZERO
		#elif GlobalScreenTransitionTimer.time_left<=0:
		##for i in get_tree().current_scene.get_children():
		##if i is enemy:
		#if new_enemy!=null:
		#new_enemy.set_physics_process(true)
	#finding way to despawn all Enemies upon screen transition
		#if GlobalScreenTransitionTimer.time_left > 0:
		#for anyNode in get_tree().current_scene.get_children():
		#if anyNode is enemy and anyNode.is_boss == false:
		#anyNode.queue_free()
		#new_enemy.queue_free()

	#func check_for_dead_enemy(index):
	##	if index==spawn_index:
	##		has_enemy_spawned=false
		#if enemy_to_spawn=='homer':
		#$spawn_homer_timer.start()
	#endregion

func _on_enemy_changed():
	if Engine.is_editor_hint():
		visibility=true
		
		if enemy_dictionary.has(enemy_to_spawn) and enemy_Preview==null:
			enemy_Preview=enemy_dictionary[enemy_to_spawn].instantiate()
			add_child(enemy_Preview)
		elif !enemy_dictionary.has(enemy_to_spawn):
			if enemy_Preview!=null:
				enemy_Preview.queue_free()
		
		if enemy_Preview!=null:
			enemy_Preview.global_position=global_position
			if enemy_to_spawn=="batallion_balloon_delivery":
				enemy_Preview.riotToDeliver=riotToDeliver

func _update_disappear_nodes():
	for i in disappear_nodes:
		var node=get_node_or_null(disappear_nodes[i])
		if node:
			node.visible=visibility
			
func _physics_process(_delta: float) -> void:
	#code to delete spawned enemies
	#used to be at _process() fxn but now here cause it works here.
	#i think it works cause all instances of enemy movements and codes
	#work at _physics_process() fxn.
	if GlobalScreenTransitionTimer.is_stopped()==false:
			if new_enemy!=null: #using !=null cause i think just using "if new_enemy" can detect new_enemy variable 
				#but cannot detect enemy instance if it gets deleted.
				new_enemy.queue_free()
			#if "enemyIns" in new_enemy :#!=null:
				#if is_instance_valid(new_enemy.enemyIns):
					#new_enemy.enemyIns.queue_free()

func display_enemy(enemy_name: String, frame_display: int):
	if enemy_to_spawn == enemy_name:
		$enemy_display_sprite.frame = frame_display


var entered = false
var timer = 1


func _on_visible_on_screen_notifier_2d_screen_entered():
	entered = true


#		match enemy_to_spawn:
#			pass
#			'new_shotman':
#				var new_shotman_enemy=new_shotman.instantiate()
#				get_parent().add_child(new_shotman_enemy)
#				new_shotman_enemy.index=spawn_index
#				new_shotman_enemy.global_position=global_position


func _on_spawn_homer_timer_timeout():
	print("enemy spawner: spawner homer timeout")  #and enemy_to_spawn=='homer'
	if has_enemy_spawned and new_enemy == null and $VisibleOnScreenNotifier2D.is_on_screen() == true:
		has_enemy_spawned = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	entered = false
