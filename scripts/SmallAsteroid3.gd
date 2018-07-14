extends RigidBody2D

var rotate
var screensize
var world

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	world = get_node("../..")
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	screensize = get_viewport().size
	# set rotation speed and velocity/direction
	linear_velocity = Vector2(100, 100)
	rotate = 1500
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var collision = get_colliding_bodies()
	# if collision, remove from game
	if(collision.size() > 0):
		world.get_node("break").playing = true
		queue_free()
	pass

func _integrate_forces(state):
	set_applied_torque(rotate)
	var pos = state.get_transform().origin
	# if too far off screen, remove from game
	if(pos.x > screensize.x+50
	|| pos.y > screensize.y+50
	|| pos.x < -50 || pos.y < -50):
		self.queue_free()