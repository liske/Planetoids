extends Control

func update_level(value):
	$Level.text = "lvl%d" % value

func update_lives(value):
	$Lives.text = "V%d" % value

func update_score(value):
	$Score.text = "%06d" % value

func show_start():
	$MainMessage.text = "go!"
	$SubMessage.text = "you won't survive"
