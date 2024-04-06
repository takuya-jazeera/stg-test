class_name Effect
extends Node3D

const	UNIT_TIME = .01

var mat = preload("res://Materials/Blast.tres")
var life_time = 0.0
var elapsed_time = 0.0
var override

var t = 0
var frame = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	life_time = 2.0
	$Effect_X.material_override = mat.duplicate()
	override = $Effect_X.material_override
	$AExplode.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	if elapsed_time > UNIT_TIME :	
		t += 1
		elapsed_time = 0.0
		
		if (t % 1 == 0) :
			override.set_shader_parameter("koma",Vector3(1.0 * (frame % 4), 1.0 * (frame / 4),1.0))
			frame += 1
	
	if (t % 16 == 0) :
		queue_free()
