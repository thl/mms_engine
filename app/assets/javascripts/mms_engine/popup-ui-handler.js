$(function() {
	//$('body').append("<div id=\"popup_dialog\"></div>")
	$( '#popup_dialog' ).dialog({
		autoOpen: false,
		height: 600,
		width: 520,
		modal: true,
		position: [100,100],
		//close: function() { $('#popup_dialog').remove(); }
	});
});