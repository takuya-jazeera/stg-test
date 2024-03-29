extends Node3D

var t = 0.0
var initial_x
var freq_speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_x = position.x 
	freq_speed = randf()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	position.z += delta
	position.x = sin(t) + initial_x
	t += delta * freq_speed
	
	pass
