extends Node3D

# Parameters ( TODO: This should be implemented from the editor
#                    I need to know how to do this )

const SPEED = 0.05
const BORDER_WIDTH = 2
const BORDER_HEIGHT = 2
const BORDER_HEIGHT_OFFSET = 1
const TILT_RADIAN = PI * 1.2

const SLP_INTERVAL = 0.1 #set interval to change players posture

var character

# Whey player change the direction of morition,
# set new posture 
var primary_posture = Quaternion(0.0,0.0,0.0,1.0)
var secondary_posture = Quaternion(0.0,0.0,0.0,1.0)
var interval = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	character = $Character
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	## Get Horizontal input
	var xinput = Input.get_axis("ui_left","ui_right") # get x-axis information
	var yinput = Input.get_axis("ui_down","ui_up")    # get y-axis information

	## --------- This procedure trreats X direction things	
	if (interval > SLP_INTERVAL) :
		primary_posture = secondary_posture
		interval = 0
		
		##          |=====================|
		##        <<   Quaternion Rules!  >>
		##          |=====================|
		##
		##       Set player goal to tilt the posture
		##       Quaternion is convenient number to control 
		##       object's rotation. Mathematics of this number is 
		##       little bit complecated, but if you get the picture
		##       it's really exciting tool concerning 3D game
		##       through Discord free free to ask me!
		##       It's not only for you but for me to understand better
		##       I wrote cheat sheet to explain how quaternion works 
		##       if you interested see
		##       https://ugman.neocities.org/gallery_pics/20240318-02.png
		##
		## |---------------------------------------------------------------|
		## | keywords, Quaternion, Rotation, Slerp(Spherical Interpolation)|
		## |           sinusoidal function, sin, cos, pytagorath's theorem |
		## |           unit circule                                        |
		## |---------------------------------------------------------------|
	
		# tilt left size 
		if (xinput > 0.0): # in input is right size
			secondary_posture = Quaternion(0.0,0.0,cos(TILT_RADIAN * 0.5),sin(TILT_RADIAN * 0.5))
		# tilt right size
		elif (xinput < 0.0) :
			secondary_posture = Quaternion(0.0,0.0,cos(TILT_RADIAN * -0.5),sin(TILT_RADIAN * -0.5))
		# if there is no input
		# return to horizontal posture
		else : 
			secondary_posture = Quaternion(0.0,0.0,0.0,1.0)			
		
		## -- Slerp (Spherical Interporation)
		## Interporate rotation smoothly
		## I will explain about Slerp function
		## in the tutorial text
		
		## Shot a bullet
		## TODO implement here when player press some button
		## Player entity shoot a bullet straigth forward
		## How do i tell if press button? 
		
		# pseudo code 
		# if puress button foo
		# then create bullet at the top of player entity
		
		
	$Character.quaternion = primary_posture.slerp(secondary_posture,interval / SLP_INTERVAL)
	interval += delta 


	## --------- This procedure trreats y direction things	
	## nothing 
	
	# clip the world position within (-2.0,2.0)
	$Character.position += Vector3(SPEED * xinput, 0.0, -SPEED*yinput)
	$Character.position.x = clamp($Character.position.x, -BORDER_WIDTH,BORDER_WIDTH)
	$Character.position.z = clamp($Character.position.z, -BORDER_HEIGHT - BORDER_HEIGHT_OFFSET,BORDER_HEIGHT - BORDER_HEIGHT_OFFSET)	


	pass
