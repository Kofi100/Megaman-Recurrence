extends enemy
class_name Boss
static var bossCharacter:Boss
var activateBoss=false
var leaveUponDefeatingBoss:bool=false
func _ready() -> void:
	health=7
	bossCharacter=self
	leaveUponDefeatingBoss=true
	
func _physics_process(delta: float) -> void:
	is_boss=true
	spawn_collectables()
	disableAllCollisionShapes()
	
func disableAllCollisionShapes():
	if health<=0:
		for node in get_children():
			#if node is CollisionShape2D or node is CollisionPolygon2D:
				#node.set_deferred("disabled",true)
			if node is Area2D:
				node.set_deferred("monitoring",false)
				node.set_deferred("monitorable",false)
				node.queue_free()
func _on_timer_timeout() -> void:
	Boss.bossCharacter.activateBoss=true
	$HUD_BossBar.FillBarUp.emit()
