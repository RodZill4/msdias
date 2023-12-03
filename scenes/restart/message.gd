extends XRToolsPickable

func died(cause):
	var text : String
	if cause == "":
		text = "It looks like you managed to survive\n"
		text += "\n"
		text += "Congratulations and thanks for playing!\n"
	else:
		text = "It looks like you died from "+cause+"\n"
		text += "\n"
		text += "Maybe you want to ring the bell to try again?\n"
	$SubViewport/Label.text = text
