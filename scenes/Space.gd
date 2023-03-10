extends Node2D

func _ready():
	highscore.setup($HUD)

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
	if not planetoids.eog:
		if Input.is_action_just_pressed("spawn"):
			planetoids.start()

func _on_Timer_timeout():
	planetoids.timer_timeout()
