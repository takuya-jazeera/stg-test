class_name MiniBoss
extends Enemy

const GOD_TIME = 0.03

# ---------------------------------------------
# These parameter determines enemy's movement
# behaviors basically this enemy
# moves sinsoidal movement
# these are parameters to move that way ~~~

var damage_cooltime = 0

# ---------------------------------------------

# ---------------------------------------------
# if player destroy this 
# this flag is enabled
# and when it destroyed spawn blasting effect

# ---------------------------------------------

# ---------------------------------------------
# enemy's local time 
# this is added by delta time
# so the unit is second
# ---------------------------------------------
# var t = 0.0

# Called everframe by process()
func _movement():
	position.z += tick * speed * 0.1
	pass


# ---------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_x = position.x
	frequency = 0.3
	amplitude = 0.5 * randf() 
	#angluar_momentum = clamp(30.0 * randf(), 10.0, 20.0)
	intertia = max(20.0, 30.0 * randf())
	#$MeshInstance3D

	health = 100	
# ---------------------------------------------

func _shoot():
	if tick % 200 == 0 :
		for i in 10 :
			var bullet = BULLET_FACTORY.instantiate()
			var phi = i * PI * 0.2
			bullet.position = position + 1.5 * Vector3(0.1*cos(phi),0.0,0.1*sin(phi))
			bullet.v = 0.05 * Vector3(cos(i* PI * 0.1),0.0,sin(i * PI * 0.1))
			get_parent().add_child(bullet)
			Audio.get_node("Enemy_Shoot").play()
	

func _express_damage(action) :
	var model = $"mini-boss/Cone"
	var mat = model.get_active_material(0)
	
	mat.set_shader_parameter("flash",action)
	
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
		if bIsDamaging == true :
			damage_cooltime -= 1
			if  damage_cooltime < 0:
				bIsDamaging = false
			_express_damage(damage_cooltime * 0.1)
		else :
			_express_damage(0.1)
			#var mat =			mat.set_shader_parameter("flash",1.0)
	
	_shoot()
			
	###
	###if tick % 10 == 0 :
	####	# decision make
	#	if randf() < 0.2 :
#			var bullet = BULLET_FACTORY.instantiate()
##########		get_parent().add_child(bullet)
	
	_movement()
	
# ---------------------------------------------
	

func _on_area_3d_body_entered(body):
	
	if bIsDamaging == false :
		health -= 10
	
	if ( health < 0 ):
		var blast = BLAST_FACTORY.instantiate()
		blast.position = self.position
		get_parent().add_child(blast)
	# $AudioStreamPlayer3D.play()
		queue_free()
	
	if bIsDamaging == false : 
			 
		Audio.get_node("Damaging").play()
		bIsDamaging = true;
		damage_cooltime = 10
		
	body.queue_free()
