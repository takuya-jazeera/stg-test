extends Node3D

const BLAST_FACTORY = preload("res://Scenes/Blast.tscn")
const BULLET_FACTORY = preload("res://Scenes/EnemyBulletA.tscn")
const UNIT_TIME = 0.02


# ---------------------------------------------
# These parameter determines enemy's movement
# behaviors basically this enemy
# moves sinsoidal movement
# these are parameters to move that way ~~~
var amplitude = 2.0
var frequency = 0.0
var speed = 0.01 * UNIT_TIME
var initial_x 
var intertia = 0.0
# ---------------------------------------------

# ---------------------------------------------
# if player destroy this 
# this flag is enabled
# and when it destroyed spawn blasting effect
var bIsKilled = false
# ---------------------------------------------

# ---------------------------------------------
# enemy's local time 
# this is added by delta time
# so the unit is second
# ---------------------------------------------
# var t = 0.0
var tick = 0
var interval = 0.0


# ---------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_x = position.x
	frequency = 0.05
	amplitude = 2.0 * randf() 
	#angluar_momentum = clamp(30.0 * randf(), 10.0, 20.0)
	intertia = max(20.0, 30.0 * randf())
	#$MeshInstance3D
# ---------------------------------------------
	
	
# ---------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# if enemy get out of the world , destry itself 
	# this prevents memory leakage
	
	if position.x < -5.0 || position.x > 5.0 || position.z > 5.0 :
		queue_free()
	
	# ---------------------------------	
	# here describes enemy's sinusoidal movement 
	# if you don't know sinusoida function,
	# it's like a wave movement
	# look carefully the movement of enemy
	# it's move like this
	# ---------------------------------
	# <freq(B)>                      
	# --      --      --      -       ^
	#   -    -  -    -  -    -        | amplitude (A)
	#    -  -    -  -    -  -         |
	#     --      --      --          v
	# ---------------------------------
	#  
	# 						 (A)                  (B)                      
	position.x = initial_x + amplitude * sin (tick * frequency)
	position.z += tick * speed
	
	interval += delta
	
	if (interval > UNIT_TIME) :
		interval = 0.0
		tick += 1
	
	if tick % 10 == 0 :
		# decision make
		if randf() < 0.2 :
			var bullet = BULLET_FACTORY.instantiate()
			bullet.v = Vector3(0.0,0.0,0.03)
			bullet.position = position
			bullet.scale = Vector3(0.2,0.2,0.2)
			get_parent().add_child(bullet)
	
	## くるくる回転させる処理をここでやってます
	var theta = tick * 1.0 / intertia;
	var p = Quaternion(0.0,0.0,cos(theta),sin(theta))
	#var n = position.normalized()
	var q = Quaternion(0.0,cos(PI * (-0.1 * cos(tick * frequency)+  0.5)),0.0,
							sin(PI * (-0.1 * cos(tick*frequency) +  0.5)))

	quaternion = q * p
	
# ---------------------------------------------
	

func _on_area_3d_body_entered(body):
	bIsKilled = true
	var blast = BLAST_FACTORY.instantiate()
	blast.position = self.position
	get_parent().add_child(blast)
	# $AudioStreamPlayer3D.play()
	body.queue_free()
	queue_free()
