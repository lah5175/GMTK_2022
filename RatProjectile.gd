extends Area2D
class_name RatProjectile


var damage = 1;
var speed = 200;

var direction = Vector2();
var velocity = Vector2();

onready var target = get_node("/root/MainScene/Player");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	translate(direction * speed * delta);
	# position += velocity.normalized().rotated(rotation) * speed * delta;
	

func _on_RatProjectile_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		body.take_damage(damage);
		queue_free();


func _on_VisibilityNotifier2D_screen_exited():
	queue_free();
