extends Node


var pieces_ate = 0
var health = 200

func adjust_health(dmg):
	health = health - dmg
	
func healthy():
	return health
	
func eat():
	if pieces_ate <= 6:
		pieces_ate += 1
		health += 45
		
func pieces():
	return pieces_ate
