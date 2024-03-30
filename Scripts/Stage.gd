extends Node3D

const enemy_factory = preload("res://Scenes/Enemy.tscn")

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
		
	if (global_time % 50 == 0) :  
		var new_enemy = enemy_factory.instantiate()
		new_enemy.position = Vector3(randf() * 4.0 - 2,0.0,-8.0)
		self.add_child(new_enemy)

func _on_collision_shape_3d_tree_exited(body: Node3D):
	
	## -----------------------------------------------
	## I need to check this is true
	## I need to read the diffrence with tree and scene is
	## because scene name changes if the same objects exist.
	## -----------------------------------------------
	
	if body.name == "Bullet": 
		body.queue_free()
	pass # Replace with function body.
