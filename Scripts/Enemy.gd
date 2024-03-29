extends Node3D

var amplitude = 2.0
var frequency = 0.0
var speed = 0.1

var bIsKilled = false

var initial_x 

# enemy's local time 
var t = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	initial_x = position.x
	frequency = 2.0 * randf()
	amplitude = 3.0 * randf() 
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if position.x < -3.0 || position.x > 3.0 || position.z > 5.0 :
		queue_free()
	
	position.x = initial_x + amplitude * sin (t)
	position.z += delta
	t += delta * frequency
	

func _exit_tree():
	if bIsKilled == true :
		# spawn blast effect
		pass
