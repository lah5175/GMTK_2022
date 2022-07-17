extends Area2D


var damage: int = 5;
var speed: int = 500;

var direction: Vector2 = Vector2();

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


func _physics_process(delta):
	translate(direction * speed * delta);


func _on_VisibilityNotifier2D_screen_exited():
	queue_free();


func _on_ShieldProjectile_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Enemy":
		body.take_damage(damage);
		body.modulate.a = 0.5;
		body.start_flicker_timer();
		queue_free();
