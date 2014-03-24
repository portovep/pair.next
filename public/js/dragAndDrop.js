function dragStart(ev) {
	ev.dataTransfer.effectAllowed = "move";
	ev.dataTransfer.setData("text",ev.target.id);
	
	$(ev.target).addClass("drag-source")
}

function dragEnter(ev) {
	ev.preventDefault();
	var target = $(ev.target);
	if(target.is( "td" )) {
		$(ev.target).addClass("drag-target")
	} else {
		target.parent().addClass("drag-target");
		target.parent().addClass("drag-alt-target");
	}
	return true;
}

function dragOver(ev) {
	ev.preventDefault();
}

function dragDrop(ev) {
	var sourceId = ev.dataTransfer.getData("text");
	var targetId = ev.target.id;

	var source = $("#"+sourceId);
	var target = $("#"+targetId);

	swapElements(source[0],target[0]);

	
	target.removeClass("drag-target");
	target.removeClass("drag-alt-target");

	target.parent().removeClass("drag-source");

	ev.stopPropagation();	
	return false;
}

function dragEnd(ev) {
	var sourceElem = ev.toElement
	var source = $(sourceElem);
	source.removeClass("drag-source");
	source.removeClass("drag-target");
	source.removeClass("drag-alt-target");
	
	return false;
}

function dragLeave(ev) {

	var target = $(ev.target);
	if (target.is("td")){
		$(ev.target).removeClass("drag-target")
		//$(ev.target).removeClass("drag-source")
	} else {
		target.parent().addClass("drag-target");
		target.parent().removeClass("drag-alt-target");
	}

	$(ev.target).removeClass("drag-target")

	return true;
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
	var rows = $("#newpairs-body").children();
	var form = $("#pairingSubmissionForm");
	for (pairNumber=0;pairNumber <rows.length; pairNumber++) {
		var row = rows[pairNumber];
		var memberEntries = row.children;
		for (memberNumber=0;memberNumber<memberEntries.length;memberNumber++) {
			var cell = memberEntries[memberNumber];
			form.append('<input type="hidden" name="pair[]['+pairNumber+']['+memberNumber+']" value="'+cell.dataset.userid+'">');
		}
	}
}