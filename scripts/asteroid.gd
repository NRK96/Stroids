extends RigidBody2D

var collided
var world
var rotate
var direction = Vector2()
var screensize
var x
var y

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	world = get_node("..")
	collided = false
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	screensize = get_viewport().size
	# set rotation speed
	rotate = 1000
	# set direction speed
	if(position.x < 500):
		x = 20
	else:
		x = -20
	if(position.y < 300):
		y = 20
	else:
		y = -20
	direction = Vector2(x, y)
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var collision = get_colliding_bodies()
	# when a collision occurs set collided
	if(collision.size() > 0):
		collided = true
	if(collided):
		split()
	pass

# break asteroid into smaller asteroids
func split():
	world.get_node("break").playing = true
	# load and set position of small asteroid scene
	var scene = load("res://scenes/smallAsteroid.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("smallAsteroid")
	scene_instance.position = position
	var world = get_node("..")
	# add smaller asteroid to the game
	world.add_child(scene_instance)
	# keep score at the foreground of the game
	var pos = world.get_node("score").get_index()-1
	world.move_child(scene_instance, pos)
	# remove asteroid from the game
	self.queue_free()

func _integrate_forces(state):
	# set rotation and direction speeds
	set_applied_force(direction)
	set_applied_torque(rotate)
	var pos = state.get_transform().origin
	# remove from game once too far off screen
	if(pos.x > screensize.x+1000 
	|| pos.y > screensize.y+1000 
	|| pos.x < -1000 || pos.y < -1000):
		self.queue_free()