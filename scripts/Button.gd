extends Button
# start game
func _on_Play_pressed():
	get_tree().change_scene("res://scenes/main.tscn")
	pass
# hide/show a text box featuring the controls 
func _on_Controls_pressed():
	if(get_node("../controls box").is_visible_in_tree()):
		get_node("../controls box").hide()
	else:
		get_node("../controls box").show()
	pass
# return to main menu
func _on_Main_Menu_pressed():
	get_tree().change_scene("res://scenes/Opening.tscn")
	pass
# quit game
func _on_Quit_pressed():
	get_tree().quit()
	pass 
