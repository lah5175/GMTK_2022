extends Area2D


export var duration: float = 2.0;

var direction = Vector2();

var projectile_factory = preload("res://ShieldProjectile.tscn");

onready var parent;
onready var scene;

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = get_parent().global_position;
	$DurationTimer.wait_time = duration;
	$DurationTimer.start();
	parent = get_parent();
	scene = get_node("../..");


func _physics_process(delta):
	global_position = parent.global_position;
	
	
func reflect(damage):
	var projectile = projectile_factory.instance();
	scene.add_child(projectile);
	
	projectile.direction = parent.face_direction;
	projectile.global_position = global_position;
	projectile.rotation = parent.getCardinalRotation();
	

# Signal functions
func _on_DurationTimer_timeout():
	get_parent().is_shielding = false;
	queue_free();


# Function overrides
func get_class(): return "ParticleShield";
