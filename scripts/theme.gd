extends AudioStreamPlayer

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# play theme when scene starts
	playing = true
	pass

func _on_theme_finished():
	# when theme ends, restart theme
	playing = true
	pass
