class_name Bullet
extends Node3D

const UNIT_TIME = 0.01


var speed
var tick = 0
var interval = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	speed = 8.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interval += delta 
	position.z -= delta * speed
	
	if position.z > 10.0:
		queue_free()
	
	if interval > UNIT_TIME :
		interval = 0.0 
		tick += 1


