extends Node3D

var LIFE_TIME = 1.5
var interval = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interval += delta
	if interval > LIFE_TIME :
		queue_free()
