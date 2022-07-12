extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_neighbors(centerHex):
	var neighbors = []
	
	if(int(centerHex.x) % 2 == 0):
		neighbors.push_back(Vector3(centerHex.x-1, centerHex.y-1,get_cell(centerHex.x-1, centerHex.y-1)));
		neighbors.push_back(Vector3(centerHex.x, centerHex.y-1,get_cell(centerHex.x, centerHex.y-1)));
		neighbors.push_back(Vector3(centerHex.x+1, centerHex.y-1,get_cell(centerHex.x+1, centerHex.y-1)));
		neighbors.push_back(Vector3(centerHex.x-1, centerHex.y,get_cell(centerHex.x-1, centerHex.y)));
		neighbors.push_back(Vector3(centerHex.x, centerHex.y+1,get_cell(centerHex.x, centerHex.y+1)));
		neighbors.push_back(Vector3(centerHex.x+1, centerHex.y,get_cell(centerHex.x+1, centerHex.y)));
	else:
		neighbors.push_back(Vector3(centerHex.x-1, centerHex.y,get_cell(centerHex.x-1, centerHex.y)));
		neighbors.push_back(Vector3(centerHex.x, centerHex.y-1,get_cell(centerHex.x, centerHex.y-1)));
		neighbors.push_back(Vector3(centerHex.x+1, centerHex.y,get_cell(centerHex.x+1, centerHex.y)));
		neighbors.push_back(Vector3(centerHex.x-1, centerHex.y+1,get_cell(centerHex.x-1, centerHex.y+1)));
		neighbors.push_back(Vector3(centerHex.x, centerHex.y+1,get_cell(centerHex.x, centerHex.y+1)));
		neighbors.push_back(Vector3(centerHex.x+1, centerHex.y+1,get_cell(centerHex.x+1, centerHex.y+1)));
	
	return neighbors;


func swap_neighbors_same_color_to(hex, oldColor):
	var neighbors = get_neighbors(hex);
	var currHexColor = get_cellv(hex)
	if currHexColor == INVALID_CELL:
		return
	for hextile in neighbors:
		if hextile.z != INVALID_CELL and hextile.z == oldColor:
			swap_color(Vector2(hextile.x, hextile.y), currHexColor)

func swap_color(centerHex, newColor):
	var currColor = get_cellv(centerHex)
	if currColor == INVALID_CELL or newColor == currColor:
		return;
	set_cellv(centerHex, newColor)
	swap_neighbors_same_color_to(centerHex, currColor)
	
	
