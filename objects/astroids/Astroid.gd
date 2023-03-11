extends RigidBody2D

export (float) var scaling = 1.0 setget _scaling_set
var ttl = 10

func _ready():
	# warning-ignore:return_value_discarded
	connect("body_entered", planetoids, "astroid_collision", [self])
	#$Explosion/Timer_Free.connect("timeout", self, "_on_Timer_Free_timeout")

func _scaling_set(value):
	scaling = value
	var scale = Vector2(scaling, scaling)
	for node in get_children():
		if not node.name in ["Explosion"]:
			node.scale = scale

func _on_Timer_Free_timeout():
	print(self)
	print(self.name)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func explode():
	queue_free()
	return

func check_ttl():
	self.ttl -= 1
	if not self.ttl > 0:
		self.explode()

	#$Explosion/CPUParticles2D.emitting = true
	#$Sprite.hide()
	#$CollisionPolygon2D.queue_free()
#	$VisibilityNotifier2D.queue_free()
	#$Explosion/Timer_Free.start()
