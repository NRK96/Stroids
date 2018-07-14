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
	# display the current score
	display = "Score: " + str(globals.score)
	text = display
	pass
