extends RigidBody2D

var speed = 350

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	print("RIP")
