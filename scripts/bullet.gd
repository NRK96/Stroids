extends RigidBody2D

var screensize
var ship

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	ship = get_node("../ship")
	screensize = get_viewport().size
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var collision = get_colliding_bodies()
	# if collision, get points and remove from game
	if(collision.size() > 0):
		globals.score += 50
		get_node("..").bonus_life_score += 50
		queue_free()
	pass

func _integrate_forces(state):
	var pos = state.get_transform().origin
	# remove from game if too far off screen
	if(pos.x > screensize.x
	|| pos.y > screensize.y
	|| pos.x < 0 || pos.y < 0):
		self.queue_free()
