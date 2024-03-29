extends Node3D

const enemy_factory = preload("res://Enemy.tscn")

# global time 
# suppose that
# game time unit is 10ms
const GT_INTERVAL = 0.01
var global_time = 0
var tick = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tick += delta
	if (tick > GT_INTERVAL) : 
		global_time += 1
		tick = 0.0
		
	if (global_time % 100 == 0) :  
		var new_enemy = enemy_factory.instantiate()
		new_enemy.position = Vector3(randf() * 2.0 - 1,0.0,-8.0)
		self.add_child(new_enemy)

	
	pass
