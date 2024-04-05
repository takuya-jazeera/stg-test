class_name BossBird
extends Boss


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	health = 60
	$BirdChant.play()
	
func _express_damage(action) :
	var model = $"bird/rig_001/Skeleton3D/Manta"
	var mat = model.get_active_material(0)
	mat.set_shader_parameter("flash",action)
	pass

func _movement() :
	speed = 0.01
	position.z += speed 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	$bird/AnimationPlayer.play("rig_001Action")
	
func _shoot():
	pass

	
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
