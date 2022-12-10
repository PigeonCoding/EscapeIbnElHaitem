extends Control

func _ready():
	Consol.loggMsg("Main Menu")
	pass

func OnStartButtonPressed():
	GameMaster.currentLevelIndex += 1
	GameMaster.start()
