extends RigidBody2D

onready var viewport_size = get_viewport_rect().size

func _ready():
	self.position.x	= viewport_size.x/4 + randi() % int(viewport_size.x/2)
	self.position.y	= viewport_size.y/4 + randi() % int(viewport_size.y/2)
