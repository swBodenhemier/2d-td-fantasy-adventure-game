extends Control


func _on_start_button_pressed() -> void:
	$ButtonClickAudio.play()
	get_tree().change_scene_to_file(
		"res://scenes/levels/main_game_level.tscn"
	)

func _on_quit_button_pressed() -> void:
	$ButtonClickAudio.play()
	$QuitConfirmationDialog.popup_centered()

func _on_quit_confirmation_dialog_confirmed() -> void:
	get_tree().quit()
