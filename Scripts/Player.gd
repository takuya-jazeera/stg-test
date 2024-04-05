
	# ***************** Player.gd *************************
	# -- Coded by Takuya S 2024 March --
	#  You are libre to modify and redistribute this code 
	#  But remember that I don't take any resposiblity 
	#  if something bad is happen by running code
	#  see MIT Licence carefully
	#  I comment the code in basically in English
	#  for educational purpose
	#  however some code will which is important be written 
	#  in Japanese. If you have difficulty to read
	#  the commennt, feel free to contact me
	# *****************************************************
	# TODO: 
	#	
	# - This should be implemented from the editor
	# - ANYWAY COMPLETE THIS!!
	# - Add discription on drawin user interface 
	#	
	# *****************************************************

extends Node3D

const BULLET_FACTORY = preload("res://Scenes/Bullet.tscn")
## Constants  ----------------------------------------------------------------------------

const SPEED = 0.05			# Defines Players speed
const BORDER_WIDTH = 2			# Defines horizontal movement 
					# 	limit 横の動きの範囲を決めます
const BORDER_HEIGHT = 3.0			# Defines veritcal movement limit 
					# 	たての動きの範囲を指定します
const BORDER_HEIGHT_OFFSET = 2.5		# This is used to adjustment for visuality of the camera

const TILT_RADIAN = PI * 1.2		# Defines how much the player model is tilted across z axis
					# 	横移動したときにz軸にたいして
					# 	どれぐらいの角度で傾くかを決めます

const SLP_INTERVAL = 0.1 		# set interval to change players posture
					# 	姿勢がかわるのに何秒かかるかを指定します

## Variables -----------------------------------------------------------------------------

var character

## this is used hindering some part of 3d space
var mask 

# Whey player change the direction of morition,
# set new posture 


var primary_posture = Quaternion(0.0,0.0,0.0,1.0)
var secondary_posture = Quaternion(0.0,0.0,0.0,1.0)
var interval = 0.0
var cool_count = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	character = $Character
	mask = $Mask
	mask.quaternion = $Camera3D.quaternion
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
	
		## *****************************************************************	
		##          |=====================|		
		##        <<   Quaternion Rules!  >>		
		##          |=====================|		
		##		*J*
		##	      プレイヤーが横に移動したときに機体を少しずつ傾ける
		##       という処理をクォーターニオンを使って作ります
		##       クォーターニオンが直感的に理解できれば、	
		##       今後3Dゲームを作りたいとなったときに直面する回転をどうするか
		##       についてが分かりやすくなります。
		##
		##       またSlerpという関数を使いますが、これはざっくりいうと
		##       「向きAから向きBにすこしずつ変えていく」というものです
		##       以下に概念図のアスキーアートを書いていますのでご覧ください
		##       私も説明することで理解が深まりますので、お気軽にご質問してください
		##
		##		 __________
		##		 | Primary |
		##		 | Posture |
		##		 | 最初の   | t = 0
		##		 | 姿勢     |
		##		 ~~~   ~~~~
		## 		   _| |_
		## 		   \   /  
		## 		    \ /   t = interval / SLP_INTERVAL
		## 		     V    $Character.quaternion = primary_posture.slerp(secondary_posture,t) 
		## 		__________
		## 		|Secondary|
		## 		| Posture |
		## 		| 最後の   |  t = 1
		## 		| 姿勢     |  姿勢が完全に変わったら新しい姿勢を設定する
		## 		~~~~~~~~~~~
		##		
		##       Set player goal to tilt the posture		
		##       Quaternion is convenient number to control 		
		##       object's rotation. Mathematics of this number is 		
		##       little bit complecated, but if you get the picture		
		##       it's really exciting tool concerning 3D game		
		##       through feel free to ask me!		
		##       It's not only for you but for me to understand better		
		##		
		##  |---------------------------------------------------------------|		
		##  | keywords, Quaternion, Rotation, Slerp(Spherical Interpolation)|		
		##  |           sinusoidal function, sin, cos, pytagorath's theorem |		
		##  |           unit circule                                        |		
		##  |---------------------------------------------------------------|
		## *****************************************************************	
	
		# tilt right size 
		if (xinput > 0.0): 					# in input is right size
			secondary_posture = Quaternion(0.0,0.0,cos(TILT_RADIAN * 0.5),sin(TILT_RADIAN * 0.5))
									# tilt left size
		elif (xinput < 0.0) :
			secondary_posture = Quaternion(0.0,0.0,cos(TILT_RADIAN * -0.5),sin(TILT_RADIAN * -0.5))
									# if there is no input
									# return to horizontal posture
		else : 
			secondary_posture = Quaternion(0.0,0.0,0.0,1.0)			

	## <-- if statement end here
		
	## -- Slerp (Spherical Interporation)
	## Interpolate rotation smoothly 
	##	時間をかけてちょっとずつ向きを変えていく処理です
	##  途中の傾き具合が　pです
	##	SLP_INTERVALで決めた時間が経過したら新しい向きと一致します
	## I will explain about Slerp function
	## in the tutorial text
	
	var p = primary_posture.slerp(secondary_posture,interval / SLP_INTERVAL)
	
	## 微調整のために　X 軸に対して -90度回転させる
	var q = Quaternion(sin(-PI* 0.5 * 0.5),0.0,0.0,cos(-PI * 0.5 * 0.5))
	
	## q に　p を　かけると　上記の回転が順番に合成される
	character.quaternion = p * q


	

	## Shot a bullet

	## -- TODO implement here when player press some button
	## Player entity shoot a bullet straigth forward
	## How do i tell if press button? 
		
	# pseudo code 
	if Input.is_action_pressed("shoot") && cool_count > 0.2 :
		
		Audio.get_node("Shoot").play()
		var bullet = BULLET_FACTORY.instantiate()
		bullet.position = character.position 		
		bullet.name =  "Bullet"
		add_child(bullet)
		cool_count = 0.0
		
	cool_count += delta
	# if puress button foo
	# then create bullet at the top of player entity
		
	interval += delta 

	## --------- This procedure trreats y direction things	
	## nothing 
	
	# clip the world position within (-2.0,2.0)
	character.position += Vector3(SPEED * xinput, 0.0, -SPEED*yinput)
	character.position.x = clamp(character.position.x, -BORDER_WIDTH,BORDER_WIDTH)
	character.position.z = clamp(character.position.z, -BORDER_HEIGHT - BORDER_HEIGHT_OFFSET,BORDER_HEIGHT - BORDER_HEIGHT_OFFSET)	

