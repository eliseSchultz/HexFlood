extends Spatial

export (PackedScene) var map
var mapinstance;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var door_open = true;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(global.completedPuzzles["random"] and door_open):
		$test_game/Sprite3D.texture = load("res://assets/tiles/hexGreenCheck.png")
		$test_game/CollisionShape.disabled = true;
		$Door.visible = false
		$Door/CollisionShape.disabled = true;
		$Door/AudioStreamPlayer3D.play()
		door_open = false;

func _on_test_game_body_entered(body):
	if body.name == "Player":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mapinstance = map.instance()
		add_child(mapinstance)


func _on_test_game_body_exited(body):
	if body.name == "Player":
		if(!$AudioStreamPlayer.playing):
			$AudioStreamPlayer.play()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mapinstance.queue_free()


func _on_eyes_body_entered(body):
	if body.name == "Player":
		$eyes.visible = false;
		$eyes/AudioStreamPlayer3D.play()
		$eyes/CollisionShape.disabled = true


func _on_AudioStreamPlayer3D_finished():
	$Door.queue_free()


func _on_ChangeLevel_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://scenes/Test2.tscn")
