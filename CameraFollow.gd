extends Camera2D


onready var target = get_node("/root/SceneManager/MainScene/Player");


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = target.position;
