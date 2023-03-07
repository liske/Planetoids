extends Node

var config: ConfigFile
var astroids: Array
var idle : bool
var level: int setget _level_set
var lives: int setget _lives_set
var rng = RandomNumberGenerator.new()
var score: int setget _score_set
var _level_score: int

var viewport_size: Vector2

var hud
var ship

var ASTROID_OFFSET = -200

func _ready():
	rng.randomize()

func _level_set(value):
	level = value
	var n = 0
	for i in range(1, level + 1):
		n += i*100
	_level_score = n

	hud.update_level(value)

func _lives_set(value):
	lives = value
	hud.update_lives(value)

func _score_set(value):
	score = value
	hud.update_score(value)

	if score >= _level_score:
		self.level += 1

func _viewport_changed(scene):
	# record current viewport size
	viewport_size = scene.get_viewport_rect().size

func setup(_scene, _hud, _ship, _astroids):
	self.hud = _hud
	self.ship = _ship
	self.astroids = _astroids

	# hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# handle viewport resizing
	viewport_size = _scene.get_viewport_rect().size
	_scene.get_tree().get_root().connect("size_changed", self, "_viewport_changed", [_scene])

	# load config
	self.config = ConfigFile.new()
	var err = config.load("user://planetoids.cfg")

	# set defaults if not found
	if err != OK:
		config.set_value("footer", "left", "")
		config.set_value("footer", "right", "")
		# warning-ignore:return_value_discarded
		config.save("user://planetoids.cfg")

	# read hud configuration
	self.hud.set_footer_left(config.get_value("footer", "left", ""))
	self.hud.set_footer_right(config.get_value("footer", "right", ""))

func stop():
	self.idle = true

	hud.show_idle()

	self.ship.visible = false
	self.ship.collision_layer = 2
	self.ship.collision_mask = 0
	self.ship.position.x = 640
	self.ship.position.y = 360

func start():
	self.idle = false

	self.level = 1
	self.lives = 3
	self.score = 0

	self.ship.visible = true
	self.ship.collision_layer = 1
	self.ship.collision_mask = 1

	for child in get_children():
		child.queue_free()

	self.ship.do_spawn()

func weapon_hit(body):
	self.score += 10
	#body.queue_free()
	body.explode()

func laser_hit_astroid(laser : RigidBody2D, astroid : RigidBody2D):
	var scaling = astroid.scaling
	# ToDo: disabled astroid breaking into parts
	if false and scaling > 1.25:
		var parts = 2 + randi() % 1
		var rotation_angle = laser.rotation - PI/2
		var rotation_step = PI/parts

		scaling /= parts
		for _i in range(1, parts + 1):
			var child_astroid = spawn_astroid(scaling, scaling)

			child_astroid.global_position = astroid.global_position + Vector2.ONE.rotated(rotation_angle)*50*scaling

			child_astroid.apply_central_impulse(astroid.linear_velocity)
			astroid.add_torque(-400 + rng.randi() % 800)
			
			rotation_angle += rotation_step

	laser.queue_free()
	self.weapon_hit(astroid)

func spawn_astroid(_scale, _max_scale=2) -> RigidBody2D:
	var astroid = astroids[rng.randi() % astroids.size()].instance()

	# rotate randomly
	astroid.rotation_degrees = rng.randi() % 360

	# scale it
	astroid.scaling = min(rng.randfn(_scale, 0.25) + 0.25, _max_scale)
	astroid.mass = 100*astroid.scaling*astroid.scaling
	
	add_child(astroid)
	
	return astroid

func timer_timeout():
	var sector = rng.randi() % 4
	var astroid = spawn_astroid(1)

	# put astroid behind viewport borders
	if sector == 0:
		astroid.global_position = Vector2(rng.randi() % int(viewport_size.x), ASTROID_OFFSET)
	elif sector == 1:
		astroid.global_position = Vector2(viewport_size.x - ASTROID_OFFSET, rng.randi() % int(viewport_size.y))
	elif sector == 2:
		astroid.global_position = Vector2(rng.randi() % int(viewport_size.x), viewport_size.y - ASTROID_OFFSET)
	else:
		astroid.global_position = Vector2(ASTROID_OFFSET, rng.randi() % int(viewport_size.y))

	# it should try to hit the space ship
	astroid.apply_central_impulse(
		Vector2(200 + rng.randi() % 200, 0).rotated( self.ship.position.angle_to_point(astroid.position))
	)
	astroid.add_torque(-400 + rng.randi() % 800)

func astroid_collision(target, astroid):
	if target.name == "Ship":
		astroid.queue_free()
		hud.show_smash()
		self.ship.do_explode()
		self.lives -= 1
		if lives == 0:
			stop()
		else:
			for child in get_children():
				child.queue_free()

