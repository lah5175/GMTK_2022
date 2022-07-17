extends Area2D


export var damage: int = 1;

var direction = Vector2();

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_DurationTimer_timeout():
	queue_free();


func _on_PurpleAttack5_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		body.take_damage(damage);
