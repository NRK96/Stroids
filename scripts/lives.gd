extends LineEdit

var display

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	display = ""
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	# display the number of lives left
	display = "Lives: " + str(get_node("../ship").lives)
	text = display
	pass
