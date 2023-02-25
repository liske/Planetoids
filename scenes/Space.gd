extends Node2D

onready var astroids = [
	preload("res://objects/astroids/Astroid1.tscn"),
	preload("res://objects/astroids/Astroid2.tscn"),
	preload("res://objects/astroids/Astroid3.tscn"),
]

var ASTROID_OFFSET = -200

class Planetoids:
	var idle : bool
	var level: int setget _level_set
	var lives: int setget _lives_set
	var score: int setget _score_set

	var hud
	var ship

	func _level_set(value):
		level = value
		hud.update_level(value)

	func _lives_set(value):
		lives = value
		hud.update_lives(value)

	func _score_set(value):
		score = value
		hud.update_score(value)

	func _init(hud, ship):
		self.hud = hud
		self.ship = ship

	func idle():
		self.idle = true

		hud.show_start()

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

		self.hud.show_start()

		self.ship.visible = true
		self.ship.collision_layer = 1
		self.ship.collision_mask = 1

	func weapon_hit(body):
		self.score += 10
		body.queue_free()

#var idle_game = true
#var player_level : int setget _player_lives_set
#var player_lives : int setget _player_lives_set
#var player_score : int setget _player_score_set

var planetoids : Planetoids

onready var viewport_size = get_viewport_rect().size

func _ready():
# warning-ignore:return_value_discarded
	# hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# handle viewport resizing
	get_tree().get_root().connect("size_changed", self, "_viewport_changed")

	planetoids = Planetoids.new($HUD, $Ship)
	planetoids.idle()

func _viewport_changed():
	# record current viewport size
	viewport_size = get_viewport_rect().size

func _input(_event):
	if planetoids.idle:
		if Input.is_action_just_pressed("shoot"):
			planetoids.start()

func _on_Timer_timeout():
	var sector = randi() % 4
	var astroid = astroids[randi() % astroids.size()].instance()

	# rotate randomly
	astroid.rotation_degrees = randi() % 360

	# scale it
	var scaling = randf()*3 + 0.5
	astroid.scale = Vector2(scaling, scaling)
	astroid.mass *= scaling

	add_child(astroid)

	# put astroid behind viewport borders
	if sector == 0:
		astroid.global_position = Vector2(randi() % int(viewport_size.x), ASTROID_OFFSET)
	elif sector == 1:
		astroid.global_position = Vector2(viewport_size.x - ASTROID_OFFSET, randi() % int(viewport_size.y))
	elif sector == 2:
		astroid.global_position = Vector2(randi() % int(viewport_size.x), viewport_size.y - ASTROID_OFFSET)
	else:
		astroid.global_position = Vector2(ASTROID_OFFSET, randi() % int(viewport_size.y))

	# it should try to hit the space ship
	astroid.apply_central_impulse(
		Vector2(200 + randi() % 200, 0).rotated( $Ship.position.angle_to_point(astroid.position))
	)
	astroid.add_torque(-400 + randi() % 800)

func _on_Ship_laser_has_hit(body):
	planetoids.weapon_hit(body)
