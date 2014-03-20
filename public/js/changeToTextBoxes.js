function changeToText()
{

	// change button
	document.getElementById("changeDetailsButton").innerHTML = "Save Changes";

  // store current nickname 
	var nickname = document.getElementById("nickname").innerHTML;

  // replace div with an input box use nickname for placeholder
	$('#nickname_row').replaceWith(function() {

					return	'<div class="large-8 column chart-text"> <input id="textbox" class="no-low-margin" type="text" placeholder="' + nickname +'"/> </div>';
    });

 	document.getElementById("textbox").style.margin="0px";




}