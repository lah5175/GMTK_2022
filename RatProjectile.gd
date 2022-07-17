extends Area2D
class_name RatProjectile


var damage = 1;
var speed = 200;

var direction = Vector2();


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
	

func _on_RatProjectile_area_entered(area):
	var collider_type = area.get_class();
	print(collider_type);
	if collider_type == "ParticleShield":
		area.reflect(damage);
		queue_free();


# Function overrides

func get_class(): return "EnemyProjectile";

