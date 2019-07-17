<a href="#" class="scrollToTop animated"></a>

{literal}
<script type="text/javascript">
	$(window).scroll(function(){
		if ($(this).scrollTop() > 100) {
			$('.scrollToTop').fadeIn();
		} else {
			$('.scrollToTop').fadeOut();
		}
	});
	$('.scrollToTop').click(function(){
		$('html, body').animate({scrollTop: 0}, 800);
		return false;
	});
</script>
{/literal}