$(function(n) {
	n(".show-more-content").click(function() {
		var t = n(".text_block-overlay");
		t.toggle();

		t.is(":visible") ?
			(n(".text_block").
				css("height", "180px"),
			n(".readmore").
				text("\u0427\u0438\u0442\u0430\u0442\u044c \u0434\u0430\u043b\u0435\u0435")) :
			(n(".text_block").
				css("height", "auto"),
			n(".readmore").
				text("\u0421\u0432\u0435\u0440\u043d\u0443\u0442\u044c"));
	});
});

$(window).on('load', function() {
	var $windowWidth = $(window).width();

	if($windowWidth > 767) {
		$(function(){
			$('.menu-head-block').click(function(e) {
				e.preventDefault();
			
			  var $this = $(this);
			
			  if ($this.next().hasClass('show')) {
				  $this.next().removeClass('show');
				  $this.next().slideUp(350);
			  } else {
				  $this.parent().parent().find('li .side-menu-list').removeClass('show');
				  $this.parent().parent().find('li .side-menu-list').slideUp(350);
				  $this.next().toggleClass('show');
				  $this.next().slideToggle(350);
			  }
		  });
		});
		
	}
})

$(window).on('load', function() {
	var $windowWidth = $(window).width();

	if($windowWidth <= 767) {
		$(function(){
			$('.toggle').click(function(e) {
				e.preventDefault();
			
			  var $this = $(this);
			
			  if ($this.next().hasClass('show')) {
				  $this.next().removeClass('show');
				  $this.next().slideUp(350);
			  } else {
				  $this.parent().parent().find('li .inner').removeClass('show');
				  $this.parent().parent().find('li .inner').slideUp(350);
				  $this.next().toggleClass('show');
				  $this.next().slideToggle(350);
			  }
		  });
		});
		
	}
})

$(function() {
	$('#sw_text_links_619').on('click', function() {
		console.log(1)
		$('.ip-company-info').toggleClass('show');
	})
})

