extends Control

func update_level(value):
	$AnimationPlayer.stop()

	$AnimationPlayer/InputLabel.hide()
	$AnimationPlayer/TextEdit.hide()

	$AnimationPlayer/Level.text = "lvl%d" % value
	$AnimationPlayer/MainMessage.text = "level #%d" % value
	$AnimationPlayer/SubMessage.text = planetoids.level_slogan(value)

	$AnimationPlayer.play("Single")

func update_lives(value):
	$AnimationPlayer/Lives.text = "V%d" % value

func update_score(value):
	$AnimationPlayer/Score.text = "%06d" % value

func set_footer_left(text):
	$AnimationPlayer/FooterLeft.text = text

func set_footer_right(text):
	$AnimationPlayer/FooterRight.text = text

func update_highscore(highscore):
	var highscore_table = [
		"  #  | level |  score  | player",
		"-----+-------+---------+--------------------------------",
	]

	var pos = 1
	for hs in highscore:
		highscore_table.append(" %2d. |   %02d  | %6d  | %s" % [pos, hs.level, hs.score, hs.player.to_lower()])
		pos += 1

	if highscore_table.size() < 3:
		highscore_table.append(" %2d. |   %02d  | %6d  | %s" % [1, 1, 0, "hAl 9000"])

	$AnimationPlayer/HighscoreText.text = "\n".join(highscore_table)

func show_idle():
	$AnimationPlayer.stop()

	$AnimationPlayer/InputLabel.hide()
	$AnimationPlayer/TextEdit.hide()

	$AnimationPlayer/MainMessage.text = "planetoids"
	$AnimationPlayer/SubMessage.text = "1 cookie 1 play"

	$AnimationPlayer.play("Continuously")

func show_smash():
	$AnimationPlayer.stop()

	$AnimationPlayer/MainMessage.text = "smashed!"
	$AnimationPlayer/SubMessage.text = "the doom is coming"
	$AnimationPlayer.play("Single")

func show_end(query):
	$AnimationPlayer.stop()
	$AnimationPlayer/MainMessage.text = "game over!"
	$AnimationPlayer.play("Game Overy")

	if query:
		$AnimationPlayer/InputLabel.show()
		$AnimationPlayer/TextEdit.text = '???'
		$AnimationPlayer/TextEdit.select_all()
		$AnimationPlayer/TextEdit.show()
		$AnimationPlayer/TextEdit.grab_focus()


func _on_TextEdit_text_entered(new_text):
	planetoids.username_input(new_text)
