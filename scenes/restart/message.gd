extends XRToolsPickable

func died(cause):
	var text : String
	text = "It looks like you died from "+cause+"\n"
	text += "\n"
	text += "Maybe you want to ring the bell to try again?\n"
	$SubViewport/Label.text = text
