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
		
		# --------------------------------------------------------------
		#	k indicated the frame of blast sequence
		#	as k increases, CPU transfer to gpu 3-dimension vector
		# 
		#	CPUからGPUにデータを転送するには少し時間がかかります、
		#	UV座標とalpha値を別々に転送するより、一気に転送したほうが効率がよくなります
		#	そのためVector3でまとめてシェーダーにデータを転送します
		#
		#			(U coordinate, V coordinate, alpha)
		#					 |				|		----
		#					 |				|			|
		#					 V     			V			V
		# 			Vector3(1.0 * (k % 4), 1.0 * (k / 4),a)
		# 		_____ vec3  _____
		#		| CPU |====>| GPU |
		#		 ~~~~~~       ~~~~~
		#		% is modulo operator
		#		if you don't know modulo see
		# 		- [JPN]
		#			https://ja.wikipedia.org/wiki/%E5%89%B0%E4%BD%99%E6%BC%94%E7%AE%97 
		#		^ [ENG]
		#			https://en.wikipedia.org/wiki/Modulo
				# I' m curious how the data is transfered to GPU through
		# the spinal bus
		# TODO --> read Yusuke Fujii et al. (2023) 
		# 
		#
		# --------------------------------------------------------------
		
		# Since sprite image has 8 figures k should 
		# stop increase more than 8
		
		k = mini(k + 1,8)
		
		# expresses alpha decay wit time 
		# the constant BLAST_DECAY_MOMENT determines
		# the speed of decay
		
		var a = exp(- k * BLAST_DECAY_MOMENT)
		
		# transfer packed data to the GPU
		my_mat.set_shader_parameter("koma",Vector3(1.0 * (k % 4), 1.0 * (k / 4),a))
	
	var idx = int(min(interval * 2,8.0)) # これなんだっけ？わすれた
	
	# Expresses expansion of the bombarment
	scale = lerp(Vector3(0.0,0.0,0.0)
				,Vector3(2.0,2.0,2.0)
				,clamp(0.8 * exp(interval / LIFE_TIME),0, 1))
	
	#shader_material_parameter("koma",Vector2(idx % 4,idx / 4))
	
	#scale = lerp(Vector3(0.0,0.0,0.0),
	#		 Vector3(1.0,1.0,1.0), min(exp(interval* 0.1),1.0))
	if interval > LIFE_TIME :
		queue_free()
