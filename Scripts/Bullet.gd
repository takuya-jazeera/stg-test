extends Node3D

var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 1.0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position -= speed
	pass
