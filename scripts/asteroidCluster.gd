extends RigidBody2D

var has_one
var has_two 
var has_three
# small cluster of asteroids that spawn once a larger asteroid is destroyed
func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	has_one = self.has_node("Small Asteroid") 
	has_two = self.has_node("Small Asteroid 2") 
	has_three = self.has_node("Small Asteroid 3") 
	# once all small asteroids are destroyed, remove from game
	if(!has_one && !has_two && !has_three):
		queue_free()
	pass