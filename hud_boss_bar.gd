extends CanvasLayer
signal FillBarUp
var foundBoss:bool=false
@export var BosstextureProgressBar:TextureProgressBar
@export var usingBossTextBar:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalScript.boss and foundBoss==false:
		match usingBossTextBar:
			false:
				$ProgressBar.max_value=GlobalScript.boss.health
				$ProgressBar.visible=false
				#$ProgressBar.value=0
				FillBarUp.connect(BossReady)
				foundBoss=true
			true:
				if BosstextureProgressBar:
					$ProgressBar.visible=false
					BosstextureProgressBar.max_value=GlobalScript.boss.health
					BosstextureProgressBar.visible=false
					FillBarUp.connect(BossReady)
					foundBoss=true
	if GlobalScript.boss:
		match usingBossTextBar:
			false:
				$ProgressBar.value=GlobalScript.boss.health
			true:
				if BosstextureProgressBar:
					BosstextureProgressBar.value=GlobalScript.boss.health
		

func BossReady():
	if get_parent():
		#get_parent().set_physics_process(false)
		#get_tree().set_pause(true)
		print(name,"Froze Physics of Scene")
		var tween=create_tween()
		tween.connect("finished",TweenFinished)
		if usingBossTextBar==false:
			$ProgressBar.visible=true
			tween.tween_property($ProgressBar,"value",$ProgressBar.max_value,1).from(0)
		elif usingBossTextBar==true and BosstextureProgressBar:
			BosstextureProgressBar.visible=true
			tween.tween_property(BosstextureProgressBar,"value",BosstextureProgressBar.max_value,1).from(0)
func TweenFinished():
	if get_parent():
		#get_tree().set_pause(false)
		#get_parent().set_physics_process(true)
		pass
