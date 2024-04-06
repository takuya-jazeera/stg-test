extends Node3D

const enemy_factory = preload("res://Scenes/Enemy.tscn")
const boss_factory = preload("res://Scenes/MiniBoss.tscn")
const bird_factory = preload("res://Scenes/Bird.tscn")
# global time 
# suppose that
# game time unit is 10ms
const GT_INTERVAL = 0.01
var global_time = 0
var tick = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var parser = XMLParser.new()
	parser.open("Res/test.xml")
	while parser.read() != ERR_FILE_EOF :
		var node_name = parser.get_node_name()
		var attributes_dict = {}
		for idx in range(parser.get_attribute_count()):
			attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
		print(node_name ,":", attributes_dict)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	tick += delta
	if (tick > GT_INTERVAL) : 
		global_time += 1
		tick = 0.0
		
	if (global_time % 50 == 0) :  
		var new_enemy = enemy_factory.instantiate()
		new_enemy.position = Vector3(randf() * 4.0 - 2,0.0,-6.0)
		self.add_child(new_enemy)
		
	if (global_time % 1000 == 0) :
		var new_boss = boss_factory.instantiate()
		new_boss.position = Vector3(0.0,0.0,-6.0)
		self.add_child(new_boss)
		
	if (global_time % 1500 == 0):
		var new_bird = bird_factory.instantiate()
		new_bird.position = Vector3(randf()-1.0,0.0,-6.0)       
		self.add_child(new_bird)
		
	var bgmat = $background.get_active_material(0)
	bgmat.set_shader_parameter("phases",Vector2(0.01 * global_time,-0.01* global_time))

func _on_collision_shape_3d_tree_exited(body: Node3D):
	
	## -----------------------------------------------
	## I need to check this is true
	## I need to read the diffrence with tree and scene is
	## because scene name changes if the same objects exist.
	## -----------------------------------------------
	
	if body.name == "Bullet": 
		body.queue_free()
	pass # Replace with function body.
