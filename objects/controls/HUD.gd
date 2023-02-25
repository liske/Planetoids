extends Control

func update_level(value):
	$Level.text = "lvl%d" % value

func update_lives(value):
	$Lives.text = "V%d" % value

func update_score(value):
	$Score.text = "%06d" % value

func show_idle():
	$MainMessage.text = "planetoids"
	$SubMessage.text = "1 cookie 1 play"

func show_start():
	$MainMessage.text = "level #1"
	$SubMessage.text = "to easy to fail"
