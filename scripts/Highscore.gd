extends Node

var HIGHSCORE_FN = 'user://highscore.json'

func load_highscore():
	var highscores = []

	var file = File.new()
	if file.open(HIGHSCORE_FN, File.READ) == OK:
		var res = JSON.parse(file.get_as_text())
		file.close()
		if res.error == OK:
			highscores = res.result

	return highscores

func add_highscore(score, level, player):
	var highscores = load_highscore()
	
	highscores.append({
		'score': score,
		'level': level,
		'player': player,
	})

	var file = File.new()
	if file.open(HIGHSCORE_FN, File.WRITE) == OK:
		file.store_string(JSON.print(highscores))
		file.close()

func check_highscore(score):
	var highscores = load_highscore()

	return true

	for i in highscores:
		if score > i.score:
			return true

	return false
