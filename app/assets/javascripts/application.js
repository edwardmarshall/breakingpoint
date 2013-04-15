// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {

	$(document).on('click', '#nav a', function(){
		var target = $(this);
		var hash = this.hash;
		var destination = $(hash).offset().top - 24;

		stopAnimatedScroll();

		$('#nav li').removeClass('on');
		target.parent().addClass('on');

		 $('html, body').stop().animate({ 
			scrollTop: destination
		}, 400, function() { window.location.hash = hash; });
		return false;
	});

	function stopAnimatedScroll(){
		if ( $('*:animated').length > 0 ) { $('*:animated').stop(); }
	}
	if(window.addEventListener) {
	    document.addEventListener('DOMMouseScroll', stopAnimatedScroll, false);
	}
	document.onmousewheel = stopAnimatedScroll;

	if($('body').hasClass('home')){
		console.log("has home");
		var $filter = $('#nav');
		var $filterSpacer = $('<div />', {
			"class": "filter-drop-spacer",
			"height": $filter.outerHeight()
		});
	  

		if ($filter.size())
		{
			$(window).scroll(function ()
			{     
				if (!$filter.hasClass('fix') && $(window).scrollTop() > $filter.offset().top)
				{
					$filter.before($filterSpacer);
					$filter.addClass("fix");
				}
				else if ($filter.hasClass('fix')  && $(window).scrollTop() < $filterSpacer.offset().top)
				{
					$filter.removeClass("fix");
					$filterSpacer.remove();
				}
			});
		}
	}

});

