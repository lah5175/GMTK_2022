extends Node2D

const Credits = preload("res://CreditsScene.tscn")

func _on_TransitionScreen_transitioned():
	$MainScene.add_child(Credits.instance());
