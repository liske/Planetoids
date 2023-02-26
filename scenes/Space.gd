extends Node2D

func _ready():
	planetoids.setup(
		# main scene object
		self,
		# HUD object
		$HUD,
		# ship object
		$Ship,
		# astroid scenes
		[
			preload("res://objects/astroids/Astroid1.tscn"),
			preload("res://objects/astroids/Astroid2.tscn"),
			preload("res://objects/astroids/Astroid3.tscn"),
		])
	planetoids.stop()

func _input(_event):
	if planetoids.idle:
		if Input.is_action_just_pressed("shoot"):
			planetoids.start()

func _on_Timer_timeout():
	planetoids.timer_timeout()
