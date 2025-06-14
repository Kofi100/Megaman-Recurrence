extends CharacterBody2D
##This is for declaring and placing every enemy under the power of OOP
class_name enemy
##This sets the starting health of an enemy
var health = 1
##This sets amount of damage a player should receive upon hitting an enemy
var playerdamagevalue = 1
var enemyreceivedamagevalue = 1
var state = ""
var index: int
var distance_x: int = 0
var distance_y: int = 0
var timeLeft:float=0
var hasBeenHurt:bool=false

var boss_defeated: Signal
var collectables_list = {
	1: preload("res://miscellenaous/small_health_capsule.tscn"),
	2: preload("res://miscellenaous/large_health_capsule.tscn"),
	3: preload("res://miscellenaous/small_weapon_capsule.tscn"),
	4: preload("res://miscellenaous/large_health_capsule.tscn"),
	5: preload("res://miscellenaous/life_up.tscn")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


var is_boss = false
var BossDefenseShot1: int = 0
var BossDefenseShot2: int = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_boss == false:
		if GlobalScreenTransitionTimer.time_left > 0:
			set_physics_process(false)
		elif GlobalScreenTransitionTimer.time_left <= 0:
			set_physics_process(true)


var collectable


func calculate_player_distance():
	distance_x = GlobalScript.playerposx - global_position.x
	distance_y = global_position.y - GlobalScript.playerposy


func spawn_collectables():
	if health <= 0:
		#get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)
		if is_boss == false:
			GlobalScript.spawn_collectable_no = randi_range(1, 100)  #18
			if collectables_list.has(GlobalScript.spawn_collectable_no):
				collectable = collectables_list[GlobalScript.spawn_collectable_no]

			if collectable != null:
				var new_collectable = collectable.instantiate()
				new_collectable.position = position
				get_tree().current_scene.add_child(new_collectable)#adds collectable to current scene instead of parent of enemy to prevent unwanted spawns
				if new_collectable.delete_spawnable_timer != null:
					#print('delete timer triggered')
					new_collectable.delete_spawnable_timer.start()
			else:
				pass
				#print("its a null case of the collectanles")
				#print("spawn_collectable_no:", GlobalScript.spawn_collectable_no)
			queue_free()
		if is_boss == true:
			boss_defeated.emit()
			self.set_physics_process(false)
			self.visible = false
			var explosionSpread=preload("res://miscellenaous/effects/explosion_scene.tscn").instantiate()
			get_parent().add_child(explosionSpread)
			explosionSpread.global_position=global_position
			#self.global_position = Vector2(-500, 500)
		var explosion = preload("res://enemy/effects/explosion_enemy.tscn")
		var explsion_new = explosion.instantiate()
		get_parent().add_child.call_deferred(explsion_new)
		explsion_new.position = position
var hurtEffectNo=2
func hurtFlash(enemySprite):
	if enemySprite!=null and enemySprite is AnimatedSprite2D or enemySprite is Sprite2D:
		match hurtEffectNo:
			1:#changes visibility
				if hasBeenHurt==true:
					#var previous_Color=enemySprite.get_modulate()
					enemySprite.visible=false
					
					#enemySprite.set_modulate(Color.BLACK)
					#set_modulate()
					await get_tree().create_timer(.1).timeout
					enemySprite.visible=true
					#enemySprite.set_modulate(previous_Color)
					hasBeenHurt=false
			2:#uses a shader to change the visible part of the sprite to flash white for a while
				var shader=load("res://resources/enemyFlash_EffectShader.gdshader")
				if shader:
					var materialCustom=ShaderMaterial.new()
					materialCustom.shader=shader
					enemySprite.material=materialCustom
				if hasBeenHurt==true:
					#var previous_Color=enemySprite.get_modulate()
					enemySprite.material.set_shader_parameter("isActive",true)
					#enemySprite.visible=false
					
					#enemySprite.set_modulate(Color.BLACK)
					#set_modulate()
					await get_tree().create_timer(.1).timeout
					#enemySprite.visible=true
					enemySprite.material.set_shader_parameter("isActive",false)
					#enemySprite.set_modulate(previous_Color)
					hasBeenHurt=false
