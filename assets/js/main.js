$(document).ready(function() {
	function loadRandomReaction() {
		$.getJSON('/api/reactions/random', function(json) {
			$('article img#reaction-image').attr('src', json.reaction.image);
			$('footer a').attr('href', json.reaction.url);
			$('footer h1').html(json.reaction.id + "/" + json.count + ": " + json.reaction.title)
			$('footer h2').html(json.reaction.feed.title)
		})
	}

	loadRandomReaction();	
	setInterval(function() { loadRandomReaction() }, 10000);
});