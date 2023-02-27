extends RigidBody2D

onready var viewport_size = get_viewport_rect().size

func _physics_process(_delta):
	# wrap around screen edges
	position.x = wrapf(position.x, 0, viewport_size.x)
	position.y = wrapf(position.y, 0, viewport_size.y)


func _on_Timer_timeout():
	queue_free()
