extends Node3D

# ---------------------------------------------
# These parameter determines enemy's movement
# behaviors basically this enemy
# moves sinsoidal movement
# these are parameters to move that way ~~~
var amplitude = 2.0
var frequency = 0.0
var speed = 0.1
var initial_x 
# ---------------------------------------------

# ---------------------------------------------
# if player destroy this 
# this flag is enabled
# and when it destroyed spawn blasting effect
var bIsKilled = false
# ---------------------------------------------

# ---------------------------------------------
# enemy's local time 
# this is added by delta time
# so the unit is second
# ---------------------------------------------
var t = 0.0


# ---------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_x = position.x
	frequency = 2.0 * randf()
	amplitude = 3.0 * randf() 
# ---------------------------------------------
	


# ---------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# if enemy get out of the world , destry itself 
	# this prevents memory leakage
	
	if position.x < -3.0 || position.x > 3.0 || position.z > 5.0 :
		queue_free()
	
	# ---------------------------------	
	# here describes enemy's sinusoidal movement 
	# if you don't know sinusoida function,
	# it's like a wave movement
	# look carefully the movement of enemy
	# it's move like this
	# ---------------------------------
	# <freq(B)>                      
	# --      --      --      -       ^
	#   -    -  -    -  -    -        | amplitude (A)
	#    -  -    -  -    -  -         |
	#     --      --      --          v
	# ---------------------------------
	#  
	# 						 (A)                  (B)                      
	position.x = initial_x + amplitude * sin (t * frequency)
	position.z += delta
	
	# 
	t += delta
	
# ---------------------------------------------
	
func _exit_tree():
	if bIsKilled == true :
		# spawn blast effect
		pass
