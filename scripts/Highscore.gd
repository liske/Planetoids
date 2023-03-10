extends Node

var hud

var HIGHSCORE_FN = 'user://highscore.json'
var HIGHSCORE_MAX_ENTRIES = 10

func setup(_hud):
	self.hud = _hud

	hud.update_highscore(self.load_highscore())

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

	var position = get_highscore_position(score)
	highscores.insert(position - 1, {
		'score': score,
		'level': level,
		'player': player,
	})

	if highscores.size() > HIGHSCORE_MAX_ENTRIES:
		highscores.resize(HIGHSCORE_MAX_ENTRIES)

	var file = File.new()
	if file.open(HIGHSCORE_FN, File.WRITE) == OK:
		file.store_string(JSON.print(highscores))
		file.close()

	hud.update_highscore(highscores)

func get_highscore_position(score):
	var highscores = load_highscore()
	var pos = highscores.size()

	for i in range(0, highscores.size()):
		if score > highscores[i].score:
			pos = i
			break

	if pos < HIGHSCORE_MAX_ENTRIES:
		return pos + 1
	else:
		return -1

func check_highscore(score):
	return get_highscore_position(score) > -1
