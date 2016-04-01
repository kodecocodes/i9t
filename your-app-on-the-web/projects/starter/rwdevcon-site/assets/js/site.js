$(function() {
    
	var scrollH = $(window).scrollTop();
	var winW = $(window).width();
	var winH = $(window).height();

    
    // Set initial scrollTop for window
	setTimeout(function(){
		$(window).scrollTop(0);
	}, 100);


	// Cache Selectors
	$header = $('#header');
	$nav    = $('#side_nav');
	$home   = $('#home');


	// Fix iPad 100% height bug
	var isiPad = navigator.userAgent.match(/iPad/i) != null;

	function reLayout(){
		if(isiPad){
			if(window.innerHeight < 800){
				$home.css('height', window.innerHeight + 'px');
			}else{
				$home.css('height', 660 + 'px');
			}
		}
	}

	// On window resize
	$(window).resize(function(){
		reLayout()
	});
	
	// On iPad orientation change
	window.onorientationchange = function(){
	   reLayout();
	}
	
	// Initial layout call
	reLayout();


	// Bind to window scroll event
	$(window).scroll(function(event) {
		scrollH = $(this).scrollTop();

		if(scrollH > 20){
			$header.addClass('scroll');
		}else{
			$header.removeClass('scroll');
		}

		if(scrollH > 830){
			$header.addClass('hide');
		}else{
			$header.removeClass('hide');
		}
	});


	// Navigation
	$('[data-section]').click(function(e) {
		e.preventDefault();

		var id      = '#' + $(this).data('section');
		var offset  = $(id).offset().top + 5;
		var current = $(window).scrollTop();

		var speed = (offset > current)? (offset - current) * 0.7 : (current - offset) * 0.7;

		$('html, body').scrollIt({top:offset, left:0}, speed);
	});


	// Masonry Gallery
	$gallery = $('#gallery_grid');
	
	// $gallery.masonry({
	// 	itemSelector: '.grid-item',
	// 	columnWidth: '.grid-sizer'
	// });

	$gallery.packery({
		itemSelector: '.grid-item',
		columnWidth: '.grid-sizer',
		transitionDuration: 0,
		percentPosition: true
	});


	// Video filters
	$videos = $('.video');

	function showAllVideos(){
		// Reset filters
		$('[data-filter]').removeClass('active');
		$('#show_all').addClass('active');

		// Show videos
		$videos.show();
	}

	function hideAllVideos(){
		// Reset filters
		$('[data-filter]').removeClass('active');
		$('#show_all').removeClass('active');

		// Show videos
		$videos.hide();
	}

	$('#show_all').click(function(e){
		e.preventDefault();
		
		showAllVideos();
	});

	$('[data-filter]').click(function(e) {
		e.preventDefault();

		$this  = $(this);
		$items = $('.' + $this.data('filter'));

		hideAllVideos();

		// Show videos
		$items.show();
		$this.addClass('active');
	});

	// Fix vertical heights for video thumbs
	function fixThumbsHeight(){
		var currentTallest = 0,
			currentRowStart = 0,
			rowDivs = new Array(),
			$el,
			topPos = 0;

		$('.video').each(function(){
			$el    = $(this);
			topPos = $el.position().top;

			if(currentRowStart !== topPos){
				// We just came to a new row.  Set all the heights on the completed row
				for(currentDiv = 0; currentDiv < rowDivs.length; currentDiv++){
					rowDivs[currentDiv].height(currentTallest);
				}

				// Set the variables for the new row
				rowDivs.length  = 0; // empty the array
				currentRowStart = topPos;
				currentTallest  = $el.height();
				rowDivs.push($el);
			}else{
				// Another div on the current row.  Add it to the list and check if it's taller
				rowDivs.push($el);
				currentTallest = (currentTallest < $el.height())? ($el.height()) : (currentTallest);
			}

			// The last row
			for(currentDiv = 0; currentDiv < rowDivs.length; currentDiv++){
				rowDivs[currentDiv].height(currentTallest);
			}
		});

		// console.log('Fixed thumbs');
	}
	fixThumbsHeight();

	// Fix thumb height after window resize
	var resizedTimeout;
	$(window).resize(function(e) {
		clearTimeout(resizedTimeout);

		resizedTimeout = setTimeout(function(){
			fixThumbsHeight();
			clearTimeout(resizedTimeout);
		}, 500)
	});

});