function changeToText()
{

	// change button
	document.getElementById("changeDetailsButton").innerHTML = "Save Changes";
   $('#changeDetailsButton').replaceWith(function() {

					return	'	<input type="submit" class="button expand" value="Save Changes" />';
    });

  // store current nickname 
	var nickname = document.getElementById("nickname").innerHTML;

  // replace div with an input box use nickname for placeholder
	$('#nickname_row').replaceWith(function() {

					return	'<div class="large-8 column chart-text"> <input id="textbox" class="no-low-margin" name="new_nickname" type="text" value="' + nickname +'" placeholder="Nickname"/> </div>';
    });

 	document.getElementById("textbox").style.margin="0px";

	$('#extra_row').replaceWith(function() {

					return	'<div class="large-12 column chart-text"> <textarea name="new_extra" class="no-low-margin" laceholder="Share a little about yourself."></textarea> </div>';
  });


        

}