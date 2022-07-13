extends Node2D

onready var hexmap = $HexMap;

var turn_amount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	gen_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("red"):
		hexmap.swap_color(hexmap.start_hex, 0)
		turn_amount += 1
	if Input.is_action_just_pressed("green"):
		hexmap.swap_color(hexmap.start_hex, 1)
		turn_amount += 1
	if Input.is_action_just_pressed("yellow"):
		hexmap.swap_color(hexmap.start_hex, 2)
		turn_amount += 1
	if Input.is_action_just_pressed("blue"):
		hexmap.swap_color(hexmap.start_hex, 3)
		turn_amount += 1
		
	$Label.text = "Turns: " + String(turn_amount);
	
	if(check_win()):
		$WinnerLabel.visible = true;
		global.completedPuzzles["random"] = true
		

func gen_map():
	var width = 1
	var height = 1
	while(width <= 7):
		while(height <= 6):
			hexmap.set_cell(width, height, randi() % 4)
			height += 1
		width += 1
		height = 1
			

func check_win():
	var usedCells = hexmap.get_used_cells()
	var cellColor = hexmap.get_cellv(usedCells[0])
	for cell in usedCells:
		if hexmap.get_cellv(cell) != cellColor:
			return false
	return true
		

func _on_ButtonNewGame_pressed():
	turn_amount = 0
	$WinnerLabel.visible = false;
	gen_map()


func _on_YellowTextureButton_pressed():
	hexmap.swap_color(hexmap.start_hex, 2)
	turn_amount += 1


func _on_RedTextureButton_pressed():
	hexmap.swap_color(hexmap.start_hex, 0)
	turn_amount += 1


func _on_BlueTextureButton_pressed():
	hexmap.swap_color(hexmap.start_hex, 3)
	turn_amount += 1


func _on_GreenTextureButton_pressed():
	hexmap.swap_color(hexmap.start_hex, 1)
	turn_amount += 1
