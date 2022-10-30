extends Control


func OnStartButtonPressed():
	Consol.logg("main menu!!!")
	GameMaster.currentLevelIndex += 1
	GameMaster.start()
