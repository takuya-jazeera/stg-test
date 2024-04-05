extends MeshInstance3D

var theta = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	theta += delta * 0.1
	quaternion = Quaternion(0.0,cos(theta * 0.5),0.0,sin(theta * 0.5))
	pass
