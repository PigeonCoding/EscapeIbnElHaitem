extends Control

onready var children = get_children()
var player = null
var text = []
var editInput
var currentInput = ""
var focused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#player = get_node("/root/GameMaster/player")
	for i in children:
		var ii = i.name.substr(0, 5)
		if  ii == "Label":
			print("found label")
			i.text = ""
			text.append(i)
		else:
			editInput = i

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and currentInput != "":
		for i in text.size():	
			if text[i].text != "":
				text[i - 1].text = text[i].text
				text[i].text = ""
		text[text.size() - 1].text = currentInput
		editInput.text = ""
		if player:
			player.prnt()
	
	if Input.is_action_just_pressed("consol"):
		editInput.grab_focus()
		focused = true
	
	if focused and Input.is_action_just_pressed("ui_cancel"):
		editInput.release_focus()
		focused = false
func OnEditedLine(new_text):
	currentInput = new_text

func OnMouseEntered():
	editInput.grab_focus()
