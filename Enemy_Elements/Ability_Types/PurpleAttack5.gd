extends Area2D


export var damage: int = 1;

var direction = Vector2();
var parent; # This is a hack because I'm pressed for time

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_DurationTimer_timeout():
	parent.stop_casting();
	queue_free();


func _on_PurpleAttack5_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		body.take_damage(damage);


# Function overrides
func get_class(): return "EnemyProjectile";


func _on_PurpleAttack5_area_entered(area):
	var collider_type = area.get_class();
	print(collider_type);
	if collider_type == "ParticleShield":
		area.reflect(damage);
		queue_free();
