extends Control

func update_level(value):
	$Level.text = "lvl%d" % value

func update_lives(value):
	$Lives.text = "V%d" % value

func update_score(value):
	$Score.text = "%06d" % value

func set_footer_left(text):
	$FooterLeft.text = text

func set_footer_right(text):
	$FooterRight.text = text

func show_idle():
	$AnimationPlayer.stop()

	$AnimationPlayer/MainMessage.text = "planetoids"
	$AnimationPlayer/SubMessage.text = "1 cookie 1 play"
	$AnimationPlayer.play("Continuously")

func show_start():
	$AnimationPlayer.stop()

	$AnimationPlayer/MainMessage.text = "level #1"
	$AnimationPlayer/SubMessage.text = "to easy to fail"
	$AnimationPlayer.play("Single")
