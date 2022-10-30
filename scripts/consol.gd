extends Control

onready var children = get_children()
onready var GameMaster = get_parent()
var player = null
var text = []
var editInput
var currentInput = ""
var focused = false
var shown = false

var commands = {
	"test": [funcref(self, "prnt"), "", "shit not done lol"],
	"reload": [funcref(self, "reloadCurrentScene"), "", "reloaded scene"],
	"test2": [funcref(self, "prnt"), "", "shit not done 2"],
	"help": [funcref(self, "prnt"), "", ""]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	commands["help"][2] = commands.keys()
	
	for i in children:
		var ii = i.name.substr(0, 5)
		if  ii == "Label":
			i.text = ""
			text.append(i)
		else:
			editInput = i

func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i) + ", "
	return s

func logg(strr):
	for i in text.size():
		if text[i].text != "" and i - 2 >= 0:
			text[i - 2].text = text[i].text
			text[i].text = ""
		if strr != "": 
			text[text.size() - 2].text = strr
		if strr in commands:
			commands[strr][0].call_func()
			if strr != "help":
				text[text.size() - 1].text = commands[strr][2]
			else:
				text[text.size() - 1].text = array_to_string(commands[strr][2])
		elif strr != "" and !(strr in commands):
			text[text.size() - 1].text = "command not found"
		editInput.text = ""
		currentInput = ""
		strr = ""

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and currentInput != "":
		logg(currentInput)
	
	
	if Input.is_action_just_pressed("consol"):
		if !shown:
			editInput.grab_focus()
			focused = true
			rect_scale = Vector2(1 , 1)
			shown = true
	
	
	
	if focused and Input.is_action_just_pressed("ui_cancel"):
		if shown:
			editInput.release_focus()
			focused = false
			rect_scale = Vector2(1, 0)
			shown = false

func OnEditedLine(new_text):
	currentInput = new_text

func OnMouseEntered():
	editInput.grab_focus()

# custom functions for consol
func reloadCurrentScene():
	var _l = get_tree().reload_current_scene()

func prnt():
	print("shit not done")
