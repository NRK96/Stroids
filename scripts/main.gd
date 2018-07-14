extends Node

var x
var y
var bonus_life_score

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	globals.dead = false
	globals.score = 0
	bonus_life_score = 0
	randomize()
	# create timer to update score every second
	var score_timer = Timer.new()
	score_timer.connect("timeout", self, "update_score")
	score_timer.set_wait_time(1)
	self.add_child(score_timer)
	score_timer.start()
	# create timer to spawn in asteroids every second
	var spawn_timer = Timer.new()
	spawn_timer.connect("timeout", self, "spawn")
	spawn_timer.set_wait_time(1)
	self.add_child(spawn_timer)
	spawn_timer.start()
	pass

func update_score():
	# every second alive, gain 10 points
	if(!globals.dead):
		globals.score += 10
		bonus_life_score += 10

func _process(delta):
	# every 5000 points, get a bonus life
	if(bonus_life_score >= 5000):
		get_node("ship").lives += 1
		bonus_life_score -= 5000

func spawn():
	# load and set position of asteroid scene
	var scene = load("res://scenes/asteroid.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("asteroid")
	# set random values to spawn in asteroids at random locations
	var x_chooser = int(rand_range(1, 5))
	var y_chooser = int(rand_range(1, 4))
	if(x_chooser == 1):
		x = -60
	if(x_chooser == 2):
		x = 700
	if(x_chooser == 3):
		x = 300
	if(x_chooser == 4):
		x = 1150
	if(y_chooser == 1):
		y = -60
	if(y_chooser == 2):
		y = 780
	if(y_chooser == 3):
		y = 390
		if(x_chooser == 1 || x_chooser == 2):
			x = -60
		else:
			x = 1150
	scene_instance.position = Vector2(x, y)
	# add asteroid to game
	add_child(scene_instance)
	# keep score at foreground of game
	var pos = get_node("score").get_index()-1
	move_child(scene_instance, pos)