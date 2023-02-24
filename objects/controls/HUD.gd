extends Control

func update_score(value):
	$Score.text = "%06d" % value


func update_lives(value):
	$Lives.text = "x%d" % value

func show_start():
	$MainMessage.text = "go!"
	$SubMessage.text = "you won't survive"
