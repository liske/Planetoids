extends Node2D

onready var astroids = [
	preload("res://objects/astroids/Astroid1.tscn"),
	preload("res://objects/astroids/Astroid2.tscn"),
	preload("res://objects/astroids/Astroid3.tscn"),
]

var ASTROID_OFFSET = -200
var idle_game = true

onready var viewport_size = get_viewport_rect().size

func _ready():
# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "viewport_changed")

func viewport_changed():
	viewport_size = get_viewport_rect().size

func _input(_event):
	if idle_game:
		$HUD.show_start()

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
