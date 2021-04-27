extends Node


var pieces_ate = 0
var health = 200
var location = "library"
var tipmoney = 0
var totalmoney = 0
var oldlocation = location

func _physics_process(delta):
	if location != oldlocation:
		totalmoney += tipmoney
		oldlocation = location

func adjust_health(dmg):
	health = health - dmg
	
func healthy():
	return health
	
func eat():
	if pieces_ate <= 6 and health <= 200:
		pieces_ate += 1
		if not health + 100 < 200:
			health += 100
		else:
			health = 200
	
		
func pieces():
	return pieces_ate

func addscore(score):
	tipmoney += score
