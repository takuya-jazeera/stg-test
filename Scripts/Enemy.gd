class_name Enemy
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
var health = 10

# ---------------------------------------------

# ---------------------------------------------
# if player destroy this 
# this flag is enabled
# and when it destroyed spawn blasting effect
var bIsKilled = false
var bIsDamaging = false

var damageCoolTime = 0
# ---------------------------------------------

# ---------------------------------------------
# enemy's local time 
# this is added by delta time
# so the unit is second
# ---------------------------------------------
# var t = 0.0
var tick = 0
var interval = 0.0

# Called everframe by process()
func _movement():
	position.x = initial_x + amplitude * sin (tick * frequency)
	position.z += tick * speed
	
	
	## くるくる回転させる処理をここでやってます
	var theta = tick * 1.0 / intertia;
	var p = Quaternion(0.0,cos(-theta),0.0,sin(-theta))
	#var n = position.normalized()
	#var q = Quaternion(0.0,cos(PI * (-0.1 * cos(tick * frequency)+  0.5)),0.0,
	#						sin(PI * (-0.1 * cos(tick*frequency) +  0.5)))
	quaternion = p
	#quaternion = q * p	
func _copy_material():
	var mat = $enemy1/Enemy.get_active_material(0)
	var new_mat = mat.duplicate()
	$enemy1/Enemy.material_override = new_mat
	pass
	
# ---------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_x = position.x
	frequency = 0.3
	amplitude = 0.5 * randf() 
	#angluar_momentum = clamp(30.0 * randf(), 10.0, 20.0)
	intertia = max(10.0, 30.0 * randf())
	_copy_material()
	#$MeshInstance3D3
# ---------------------------------------------
	
	
# ---------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# if enemy get out of the world , destry itself 
	# this prevents memory leakage
	
	if position.x < -5.0 || position.x > 5.0 || position.z > 5.0 :
		queue_free()
	
	interval += delta
	if (interval > UNIT_TIME) :
		interval = 0.0
		tick += 1
		damageCoolTime += 1

	if bIsDamaging:
		if damageCoolTime < 10 :
			
			var action = max(0.2,1.0 - damageCoolTime * 0.1)
			
			var mat = $enemy1/Enemy.get_active_material(0)
			mat.setup_local_to_scene()
			#var mat = model.get_active_material(0)
			mat.set_shader_parameter("flash",action)
		else :
			var action = 0.2
			var mat = $enemy1/Enemy.get_active_material(0)
			#var mat = model.get_active_material(0)
			mat.setup_local_to_scene()
			mat.set_shader_parameter("flash",action)
			bIsDamaging = false
		
	
	#if tick % 10 == 0 :
	#	# decision make
	#	if randf() < 0.1 :
	#		var bullet = BULLET_FACTORY.instantiate()
	#		bullet.v = Vector3(0.0,0.0,0.03)
	#		bullet.position = position
	#		bullet.scale = Vector3(0.2,0.2,0.2)
	#		get_parent().add_child(bullet)

	_movement()
# ---------------------------------------------
	

func _on_area_3d_body_entered(body):
	#print(body.get_parent().name)
	
	body.queue_free()
	
	if !bIsDamaging :
		bIsDamaging = true
		damageCoolTime = 0
		health -= 10 # change after I imprements weapon upgrades
		if health < 0 :
			bIsKilled = true
	
	if bIsKilled == true :
		var blast = BLAST_FACTORY.instantiate()
		blast.position = self.position
		get_parent().add_child(blast)
		# $AudioStreamPlayer3D.play()
		#body.queue_free()
		queue_free()
