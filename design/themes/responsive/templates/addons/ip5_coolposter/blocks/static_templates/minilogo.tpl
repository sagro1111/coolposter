{** block-description:tmpl_copyright **}
<div class="ip-minilogo">
	<img src="design/themes/responsive/media/images/addons/ip5_coolposter/logo-footer.png" alt="">
	<span class="ip-year-start footer-date">&copy; {if $smarty.const.TIME|date_format:"%Y" != $settings.Company.company_start_year}{$settings.Company.company_start_year}-{/if}{$smarty.const.TIME|date_format:"%Y"}</span>
</div>