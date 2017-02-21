(function ($) {
    'use strict';

	jQuery(window).on('load', function(){

		jQuery('.masonry').masonry({
			columnWidth: '.grid-sizer',
			gutter: '.gutter-sizer',
			itemSelector: '.item'
		});

	});

}(jQuery));
