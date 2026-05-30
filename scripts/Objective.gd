extends Node

signal objective_changed(new_text)

var current_objective := ""

func set_objective(text: String):
	current_objective = text
	objective_changed.emit(text)
