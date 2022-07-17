extends CanvasLayer

signal transitioned;

func _ready():
	$ColorRect.color = Color(0,0,0,0);
	
func transition():
	$AnimationPlayer.play("fade_to_black");
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black" :
		print("Emit signal transitioned")
		emit_signal("transitioned");
