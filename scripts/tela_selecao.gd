extends Node2D

func _on_btnJogar_pressed():
	GameControl.changeLevel(1)

func _on_btnCredito_pressed():
	GameControl.changeScenneCredits()

func _on_btnVoltar_pressed():
	GameControl.changeScenneMain()



func _on_BtnVoltarLevel_pressed():
	GameControl.changeLevel(GameControl.last_level)
