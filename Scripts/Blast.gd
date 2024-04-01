# -----------------------------------------------------------------
# Blast.gd
# Copyrighted by Takuya S. (2024)
# this code is distributed under MIT license																		
# -----------------------------------------------------------------

extends Node3D

const BLAST_DECAY_MOMENT = 0.04

var LIFE_TIME = 0.8
var interval = 0.0
var my_mat = preload("res://Materials/Blast.tres")
var tex_source = preload("res://Res/blast1.png")

var t = 0
var k = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	$MeshInstance3D.material_override = my_mat
	my_mat.set_shader_parameter("tex",tex_source)
	var phi = PI * randf()
	quaternion = Quaternion(0.0,cos(phi),0.0,sin(phi))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interval += delta
	t += 1
	if t % 2 == 0 :
		
		# --------------------------------------------------------------
		#	k indicated the frame of blast sequence
		#	as k increases, CPU transfer to gpu 3-dimension vector
		# 
		#	CPUからGPUにデータを転送するには少し時間がかかります、
		#	UV座標とalpha値を別々に転送するより、一気に転送したほうが効率がよくなります
		#	そのためVector3でまとめてシェーダーにデータを転送します
		# 		
		# 						TODO for me --> read Yusuke Fujii et al. (2013) 
		#
		#			(U coordinate, V coordinate, alpha)
		#					 |	|	|
		#					 |	|	|
		#					 V     	V	V
		# 			Vector3(1.0 * (k % 4), 1.0 * (k / 4),a)
		#
		# 		_____ vec3  _____
		#		| CPU |====>| GPU |
		#		 ~~~~~~       ~~~~~
		#
		#		% is modulo operator
		#		if you don't know modulo see
		#		it work look like this:
		#
		#		0 % 4 = 0
		#		1 % 4 = 1
		#		2 % 4 = 2
		#		3 % 4 = 3
		#		4 % 4 = 0
		#		5 % 4 = 1
		#		6 % 4 = 2
		#		7 % 4 = 3
		#		8 % 4 = 0
		#		9 % 4 = 1
		#		10 % 4 = 2
		#		11 % 4 = 3
		#		12 % 4 = 0
		#		and so on ...
		#		パターンはつかめたでしょうか これが 13 % 4, 14 % 4 .... となっていったら
		#		どうなっていくか想像してみてください
		#
		#		たとえば・・・
		#		I use this as like this
		#	
		#	            3 % 4  = 3
		#		       |
		#		       V
		#		 ________
		#		|_|_|_|L| <---  4 / 4 = 1
		#		|_|_|_|_|
		#		|_|_|_|_|
		#		|_|_|_|_|
		#
		#
		#	        4 % 4  = 0
		#		 |
		#		 V
		#		 ________
		#		|_|_|_|_|
		#		|L|_|_|_| <---  4 / 4 = 1
		#		|_|_|_|_|
		#		|_|_|_|_|
		#
		#		 5 % 4  = 1
		#		   |
		#		   V
		#		 ________
		#		|_|_|_|_|
		#		|_|L|_|_| <---  5 / 4 = 1
		#		|_|_|_|_|
		#		|_|_|_|_|
		#
		#		   6 % 4  = 2
		#		     |
		#		     V
		#		 ________
		#		|_|_|_|_|
		#		|_|_|L|_| <---  6 / 4 = 1
		#		|_|_|_|_|
		#		|_|_|_|_|
		#	
		#	何をやろうとしているか気が付きましたか？
		#	Don't you ring a bell what I want do?
		#  
		#	I created graphic pattern as floows
		#	今回爆発のグラフィックは
		#		 ________
		#		|0|1|2|3|
		#		|4|5|6|7| 
		#		|_|_|_|_|
		#		|_|_|_|_| 01234567　しか準備していません
		#	then
		#	だから、
		#
		#		8 % 4  = 2
		#		 |
		#		 V
		#		 ________
		#		|_|_|_|_|
		#		|_|_|_|_|
		#		|L|_|_|_| <---  8 / 4 = 2
		#		|_|_|_|_|
		#
		#	となったときグラフィックが消えてしまいます   Wow! we can't see any graphics
		#	それじゃ困った what's happning????
		#	そうはしたくないので、mini(x,y)という関数を使います 
		#	これはどちらxとyのうち小さいほうの数を出力するという関数です
		#	MINi(小さいほうの) Integer(整数) の略です
		#
		#	mini(i,7) とすれば、いくらiがふえても
		#		 ________
		#		|0|1|2|3|
		#		|4|5|6|7| 7のところでとまってくれます。
		#		|_|_|_|_|  Hmmm
		#		|_|_|_|_|
		#
		#	わたしはこうやって爆発を表現しました
		#	This is my way to express the explosion!
		#   0から7までの数字を
		#	あとは　X = mini(i,7) % 4, Y = mini(i,7) / 4　として
		#	これをシェーダーのほうに送ってあげれば、
		#						 |
		#						 V
		#					my_mat.set_shader_parameter("koma",Vector3(X,Y,a)) # 上にかいたけど、わかりにくいとおもうから
		#													   # 透明さ(a)もおくってあげようっていう考えです
		#											    
		#
		#	切り取った画像を(X,Y)に応じて張り付けてくれるっていう仕組みです
		#	もっと詳しく説明するとUV座標(UV Coordination)っていうものを
		#	理解する必要があるんだけれど、またそれは Shaders/Blast.gdshader　のほうでお話しましょう
		#	
		#	まとめると、割り算(division)'\' と　余り(modulo)'%'　を使ってあげれば上のような処理ができるってことです
		#
		# 		- [JPN]
		#			https://ja.wikipedia.org/wiki/%E5%89%B0%E4%BD%99%E6%BC%94%E7%AE%97 
		#		^ [ENG]
		#			https://en.wikipedia.org/wiki/Modulo
		# 			I' m curious how the data is transfered to GPU through

		# 
		#
		# --------------------------------------------------------------
		
		# Since sprite image has 8 figures k should 
		# stop increase more than 7
		# why 7 see upper diagram
		
		k = mini(k + 1,8)
		
		# expresses alpha decay wit time 
		# the constant BLAST_DECAY_MOMENT determines
		# the speed of decay
		
		var a = exp(- k * BLAST_DECAY_MOMENT)
		
		# transfer packed data to the GPU
		my_mat.set_shader_parameter("koma",Vector3(1.0 * (k % 4), 1.0 * (k / 4),a))
	
	var idx = int(min(interval * 2,8.0)) # これなんだっけ？わすれた
	
	# Expresses expansion of the bombarment
	scale = lerp(Vector3(0.0,0.0,0.0)
				,Vector3(2.0,2.0,2.0)
				,clamp(0.8 * exp(interval / LIFE_TIME),0, 1))
	
	#shader_material_parameter("koma",Vector2(idx % 4,idx / 4))
	
	#scale = lerp(Vector3(0.0,0.0,0.0),
	#		 Vector3(1.0,1.0,1.0), min(exp(interval* 0.1),1.0))
	if interval > LIFE_TIME :
		queue_free()
