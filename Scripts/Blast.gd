extends Node3D

const BLAST_DECAY_MOMENT = 0.04

var LIFE_TIME = 0.8
var interval = 0.0
var my_mat = preload("res://Materials/Blast.tres")
var tex_source = preload("res://Res/blast1.png")

var t = 0
var k = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	$MeshInstance3D.material_override = my_mat
	my_mat.set_shader_parameter("tex",tex_source)
	var phi = PI * randf()
	quaternion = Quaternion(0.0,cos(phi),0.0,sin(phi))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interval += delta
	t += 1
	if t % 2 == 0 :
		k += 1
		k = mini(k,8)
		var a = exp(- k * BLAST_DECAY_MOMENT)
		my_mat.set_shader_parameter("koma",Vector3(1.0 * (k % 4), 1.0 * (k / 4),a))
	
	var idx = int(min(interval * 2,8.0))
	scale = lerp(Vector3(0.0,0.0,0.0)
				,Vector3(2.0,2.0,2.0)
				,clamp(0.8 * exp(interval / LIFE_TIME),0, 1))
	
	#shader_material_parameter("koma",Vector2(idx % 4,idx / 4))
	
	#scale = lerp(Vector3(0.0,0.0,0.0),
	#		 Vector3(1.0,1.0,1.0), min(exp(interval* 0.1),1.0))
	if interval > LIFE_TIME :
		queue_free()
