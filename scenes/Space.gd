extends Node2D

onready var astroids = [
	preload("res://objects/astroids/Astroid1.tscn"),
	preload("res://objects/astroids/Astroid2.tscn"),
	preload("res://objects/astroids/Astroid3.tscn"),
]

var ASTROID_OFFSET = -200
var idle_game = true
var player_score : int setget _player_score_set
var player_lives : int setget _player_lives_set

onready var viewport_size = get_viewport_rect().size

func _ready():
# warning-ignore:return_value_discarded
	# hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# handle viewport resizing
	get_tree().get_root().connect("size_changed", self, "_viewport_changed")

func _player_score_set(value):
	player_score = value
	$HUD.update_score(value)

func _player_lives_set(value):
	player_lives = value
	$HUD.update_lives(value)

func _viewport_changed():
	# record current viewport size
	viewport_size = get_viewport_rect().size

func _input(_event):
	if idle_game:
		if Input.is_action_just_pressed("shoot"):
			start_game()

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
	self.player_score += 10
	body.queue_free()

func start_game():
	idle_game = false
	self.player_score = 0
	self.player_lives = 3
	$HUD.show_start()
