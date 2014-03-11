function dragStart(ev) {
	ev.dataTransfer.effectAllowed = "move";
	ev.dataTransfer.setData("text",ev.target.id);
}

function dragEnter(ev) {
	ev.preventDefault();
	return true;
}

function dragOver(ev) {
	ev.preventDefault();
}

function dragDrop(ev) {
	var sourceId = ev.dataTransfer.getData("text");
	var targetId = ev.target.id;

	var source = $("#"+sourceId)
	var target = $("#"+targetId)

	swapElements(source[0],target[0])

	ev.stopPropagation();	
	return false;
}

function swapElements(elm1, elm2) {
	// from http://stackoverflow.com/a/8034949
    var parent1, next1,
        parent2, next2;

    parent1 = elm1.parentNode;
    next1   = elm1.nextSibling;
    parent2 = elm2.parentNode;
    next2   = elm2.nextSibling;

    parent1.insertBefore(elm2, next1);
    parent2.insertBefore(elm1, next2);
}

function onsubmitPairings(ev) {
	var rows = $("#newpairs-body").children()
	var form = $("#pairingSubmissionForm")
	for (pairNumber=0;pairNumber <rows.length; pairNumber++) {
		var row = rows[pairNumber]
		var memberEntries = row.children
		for (memberNumber=0;memberNumber<memberEntries.length;memberNumber++) {
			var cell = memberEntries[memberNumber]
			form.append('<input type="hidden" name="pair[]['+pairNumber+']['+memberNumber+']" value="'+cell.dataset.userid+'">')
		}
	}
}