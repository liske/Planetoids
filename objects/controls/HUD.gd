extends Control

var level_submessages = [
	"to easy to fail",
	"most get this far",
	"you will stop now",
	"this is a bug in the game"
]

func update_level(value):
	$AnimationPlayer.stop()

	$Level.text = "lvl%d" % value
	$AnimationPlayer/MainMessage.text = "level #%d" % value

	# align to array start
	value -= 1

	if value in range(0, level_submessages.size()):
		$AnimationPlayer/SubMessage.text = level_submessages[value]
	else:
		$AnimationPlayer/SubMessage.text = "hahahahahhahahaha"

	$AnimationPlayer.play("Single")

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
