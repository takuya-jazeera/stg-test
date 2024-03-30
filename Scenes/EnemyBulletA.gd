extends Node3D

const UNIT_TIME = 0.01

var my_shader
var tex
var interval = 0.0
var tick = 0
var anime_frame = 0
var v = Vector3(0.0,0.0,0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	my_shader = preload("res://Materials/Blast.tres")
	tex = preload("res://Res/shoot1.png")
	my_shader.set_shader_parameter("tex",tex)
	$MeshInstance3D.material_override = my_shader
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += v
	interval += delta
	if (interval > UNIT_TIME) : 
		interval = 0.0
		tick += 1
	if tick % 10 == 0 :
		var k = anime_frame
		my_shader.set_shader_parameter("koma", Vector3(1.0 * (k % 4),0.0,1.0))
		anime_frame += 1
