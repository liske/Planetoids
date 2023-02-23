extends Node2D

var speed = 350

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	print("RIP")
