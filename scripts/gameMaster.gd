extends Spatial

var playerPrefab = preload("res://player/Player.tscn")
#var consolPrefab = preload("res://prefabs/consol.tscn")
var levelsPath = "res://prefabs/levels/"
var levels = []
var currentLevel : PackedScene
var currentLevelIndex = 0
var player

func init():
	if currentLevel:
		var level = currentLevel.instance()
		add_child(level)
		player = playerPrefab.instance()
		add_child(player)
		#Consol.player = player
		player.global_translation = get_node("/root/GameMaster/" + levels[currentLevelIndex].substr(0, levels[currentLevelIndex].length() - 5) + "/spawnPoint/").global_translation
		#player.scale = Vector3(1.25, 1.25, 1.25)

func start():
	currentLevel = load(levelsPath + levels[currentLevelIndex])
	print(currentLevelIndex)
	print(currentLevel)
	print(levels)
	print(levelsPath + levels[currentLevelIndex])
	if levels[currentLevelIndex] == "MainMenu.tscn":
		var level = currentLevel.instance()
		add_child(level)
		Consol.loggMsg("main menu bro")
		Consol.loggMsg(UsefulShit.array_to_string(levels))
	else:
		get_node("/root/GameMaster/MainMenu").queue_free()
		Consol.loggMsg("probably a level i think it's: " + levels[currentLevelIndex])
		init()

func _ready():
	get_viewport().msaa = Viewport.MSAA_4X
	levels = list_files_in_directory(levelsPath)
	#Consol.rect_scale = Vector2(1 , 0)
	start()

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	return files

func OnAreaBodyEntered(_body):
	for i in get_children():
		i.queue_free()
	init()


