extends RigidBody2D

var damage: int = 1;

var player;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_VisibilityNotifier2D_screen_exited():
	queue_free();

func _on_BossBullet_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		player.take_damage(damage);
		queue_free();
