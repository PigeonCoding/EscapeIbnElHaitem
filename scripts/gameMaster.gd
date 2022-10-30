extends Spatial

var playerPrefab = preload("res://prefabs/player.tscn")
var consolPrefab = preload("res://prefabs/consol.tscn")
var levelsPath = "res://prefabs/levels/"
var levels = []
var currentLevel
var currentLevelIndex = 0
var consol = consolPrefab.instance()

func init():
	var level = currentLevel.instance()
	add_child(level)
	var player = playerPrefab.instance()
	add_child(player)
	#print(get_node("/root/GameMaster/" + levels[currentLevelIndex].substr(0, levels[currentLevelIndex].length() - 5) + "/spawnPoint/").global_transform)
	player.transform = get_node("/root/GameMaster/" + levels[currentLevelIndex].substr(0, levels[currentLevelIndex].length() - 5) + "/spawnPoint/").transform
	player.scale = Vector3(1, 1, 1)
	
	# Called when the node enters the scene tree for the first time.
func _ready():
	levels = list_files_in_directory(levelsPath)
	add_child(consol)	
	currentLevel = load( levelsPath + levels[currentLevelIndex])
	init()


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
