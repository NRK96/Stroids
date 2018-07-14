extends RigidBody2D

export (int) var engine_thrust
export (int) var spin_thrust

var thrust
var rotation_dir
var screensize
var collided
var inc
var time_elapse
var state
var lives
var respawn_timer
var game_over_timer
var toggle_timer
var timer_timer

func _ready():
	# plays 4 seconds of toggle (used for respawning)
	timer_timer = Timer.new()
	timer_timer.set_wait_time(4)
	timer_timer.connect("timeout", self, "timer_toggle")
	timer_timer.one_shot = true
	add_child(timer_timer)
	# every half a second hide/show the ship (used for respawning)
	toggle_timer = Timer.new()
	toggle_timer.set_wait_time(0.5)
	toggle_timer.connect("timeout", self, "toggle")
	toggle_timer.paused = true
	add_child(toggle_timer)
	toggle_timer.start()
	# wait half a second to respawn
	respawn_timer = Timer.new()
	respawn_timer.connect("timeout", self, "respawn")
	respawn_timer.set_wait_time(0.5)
	respawn_timer.one_shot = true
	add_child(respawn_timer)
	# wait half a second to switch to game over screen
	game_over_timer = Timer.new()
	game_over_timer.connect("timeout", self, "game_over")
	game_over_timer.set_wait_time(0.5)
	add_child(game_over_timer)
	# start with 1 life
	lives = 1
	# not moving
	rotation_dir = 0
	thrust = Vector2()
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	collided = false
	# used for explosion animation
	time_elapse = 0
	# used for explosion animation
	inc = 1
	state = self.get_node("appearance")
	screensize = get_viewport().size
	pass

func get_input():
	# set fire button
	if(Input.is_action_just_pressed("ui_select")):
		fire_laser()
	# play thruster noise when pressed
	if(Input.is_action_just_pressed("ui_up")):
		get_node("thruster").playing = true
	# move forward while held down
	if(Input.is_action_pressed("ui_up")):
		thrust = Vector2(engine_thrust, 0)
		state.get_node("engine").show()
	# slow down and stop playing noise when unpressed
	else:
		get_node("thruster").playing = false
		state.get_node("engine").hide()
		thrust = Vector2()
	# not rotating unless specified
	rotation_dir = 0
	# press right or left and thruster noise begins
	if(Input.is_action_just_pressed("ui_right")):
		get_node("right-thruster").playing = true
	if(Input.is_action_just_pressed("ui_left")):
		get_node("left-thruster").playing = true
	# press right and begin rotating
	if(Input.is_action_pressed("ui_right")):
		state.get_node("right-engine").show()
		rotation_dir += 1
	# when unpressed, stop noise
	else:
		state.get_node("right-engine").hide()
		get_node("right-thruster").playing = false
	# press left and begin rotating
	if(Input.is_action_pressed("ui_left")):
		state.get_node("left-engine").show()
		rotation_dir -= 1
	# when unpressed, stop noise
	else:
		state.get_node("left-engine").hide()
		get_node("left-thruster").playing = false

# stops all thruster noise
func end_thrust_noise():
	get_node("thruster").playing = false
	get_node("left-thruster").playing = false
	get_node("right-thruster").playing = false

func _process(delta):
	screensize = get_viewport().size
	# get player input while alive
	if(!globals.dead):
		get_input()
	# if dead end all thrust noise
	else:
		end_thrust_noise()
	var collision = get_colliding_bodies()
	# if collided lose a life and set collided
	if(collision.size() > 0):
		lives -= 1
		collided = true
	# if collided, death animation
	if(collided):
		death(delta)

# respawn with no velocity
func respawn():
	rotation_dir = 0
	thrust = Vector2()
	toggle_timer.paused = false
	timer_timer.start()

# after toggle timer is done, pause it and reset variables
func timer_toggle():
	toggle_timer.paused = true
	state.get_node("ship").show()
	inc = 1
	globals.dead = false
	enable_collision()

# show and hide ship while respawning
func toggle():
	if(state.get_node("ship").is_visible_in_tree()):
		state.get_node("ship").hide()
	else:
		state.get_node("ship").show()

# chenge to game over scene
func game_over():
	get_tree().change_scene("res://scenes/gameOver.tscn")

# turn off all collision
func disable_collision():
	get_node("collision shape").disabled = true
	get_node("collision shape 2").disabled = true
	get_node("collision shape 3").disabled = true

# turn on all collision
func enable_collision():
	get_node("collision shape").disabled = false
	get_node("collision shape 2").disabled = false
	get_node("collision shape 3").disabled = false

# fires laser
func fire_laser():
	# loads laser scene
	var scene = load("res://scenes/bullet.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("bullet")
	# set laser to be in front of and in line with the ship
	var dir = Vector2(-sin(rotation), cos(rotation))
	# variable that ensures ship never hits the laser
	var speed_factor = linear_velocity/100*2
	var base_distance = Vector2(40,-2).rotated(rotation)
	var distance_from_me = speed_factor + base_distance
	var spawn = self.position + dir + distance_from_me
	var world = get_node("..")
	# add laser to game
	world.add_child(scene_instance)
	# set position, rotation and velocity
	scene_instance.rotation = rotation + PI/2
	scene_instance.position = spawn
	var initial_velocity = Vector2(500,0).rotated(rotation)
	var velocity = initial_velocity + linear_velocity
	scene_instance.linear_velocity = velocity
	get_node("laser").playing = true

func _integrate_forces(state):
	# apply thrust and rotation forces
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)
	var pos = state.get_transform()
	# if off screen, appear on opposite side of screen
	if(pos.origin.x > screensize.x+25):
		pos.origin.x = -25
	if(pos.origin.x < -25):
		pos.origin.x = screensize.x+25
	if(pos.origin.y > screensize.y+25):
		pos.origin.y = -25
	if(pos.origin.y < -25):
		pos.origin.y = screensize.y+25
	state.set_transform(pos)
	
func death(delta):
	# turn off collisions
	disable_collision()
	# play explosion noise
	if(inc == 1):
		get_node("explosion").playing = true
	globals.dead = true
	time_elapse = time_elapse + delta
	# begin animation
	if(time_elapse > 0.1):
		inc = inc+1
		if(inc < 11):
			# go through various levels of explosion, hiding the previous
			if(inc > 1):
				var prev = "explode " + str(inc-1)
				state.get_node(prev).hide()
			# when explosion engulfs ship, hide ship
			if(inc == 4):
				state.get_node("ship").hide()
				state.get_node("engine").hide()
				state.get_node("left-engine").hide()
				state.get_node("right-engine").hide()
			var node = "explode " + str(inc)
			state.get_node(node).show()
		# hide last explosion and begin timer
		if(inc == 11):
			state.get_node("explode 10").hide()
			collided = false
			if(lives > 0):
				respawn_timer.start()
			else:
				game_over_timer.start()
		time_elapse = 0

# when thruster noise is finished, restart
func _on_thruster_finished():
	get_node("thruster").playing = true
	pass

# when thruster noise is finished, restart
func _on_leftthruster_finished():
	get_node("left-thruster").playing = true
	pass

# when thruster noise is finished, restart
func _on_rightthruster_finished():
	get_node("right-thruster").playing = true
	pass
