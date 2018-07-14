extends LineEdit

var display
var rem_points

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	display = ""
	rem_points = 0
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	# display number of points remaining until bonus life
	rem_points = 5000-get_node("..").bonus_life_score
	display = "Points To Next Life: " + str(rem_points)
	text = display
	pass
