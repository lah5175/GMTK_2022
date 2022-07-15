extends KinematicBody2D


var current_hp: int = 10;
var max_hp: int = 10;
var move_speed: int = 250;
var damage: int = 1;

var velocity = Vector2();
var face_direction = Vector2();

onready var sprite = $AnimatedSprite;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process (delta):
  
	velocity = Vector2();

	if Input.is_action_pressed("move_up"):
		velocity.y -= 1;
		face_direction = Vector2(0, -1);
	if Input.is_action_pressed("move_down"):
		velocity.y += 1;
		face_direction = Vector2(0, 1);
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1;
		face_direction = Vector2(-1, 0);
	if Input.is_action_pressed("move_right"):
		velocity.x += 1;
		face_direction = Vector2(1, 0);
  
	velocity = velocity.normalized();
	move_and_slide(velocity * move_speed, Vector2.ZERO)
