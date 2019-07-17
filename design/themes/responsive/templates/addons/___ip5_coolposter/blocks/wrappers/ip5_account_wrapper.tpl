{if $content|trim}
	{assign var="dropdown_id" value=$block.snapping_id}
	<!--For Ajax must be on one line!-->
	<div class="ty-account-info__buttons buttons-container" id="wish_list_block">
		<div class="ip-myprofile" >
			<!-- a	href="/wishlist/" class="user-wish-link"><span class="ty-icon-star"><span class="ars">{$whishlistcount|default:0}</span></span>Избранные фото</a -->
			{if $auth.user_id}
				{assign var="return_current_url" value=$config.current_url|escape:url}
				<div id="sw_dropdown_{$dropdown_id}" class="ty-dropdown-box__title cm-combination {if $header_class}{$header_class}{/if}">
					{hook name="wrapper:onclick_dropdown_title"}
					{if $smarty.capture.title|trim}
						{$smarty.capture.title nofilter}
					{else}
						<a>{$title nofilter}</a>
					{/if}
					{/hook}
				</div>
				<a href="{"auth.logout?redirect_url=`$return_current_url`"|fn_url}" data-ca-target-id="{$block.snapping_id}" class="exit-profile exit-user-link" rel="nofollow">{if $user_info.firstname}{/if}{__("sign_out")}</a>
			{else}
				<a href="{if $runtime.controller == "auth" && $runtime.mode == "login_form"}
								{$config.current_url|fn_url}{else}
								{"auth.login_form?return_url=`$return_current_url`"|fn_url}{/if}"
								{if $settings.Security.secure_storefront != "partial"}
								data-ca-target-id="login_block{$block.snapping_id}"
								class="cm-dialog-opener cm-dialog-auto-size auth-user-link"{else}
								class="ty-btn ty-btn__primary"{/if} rel="nofollow">
					<span class="sprite-main signin-ico"></span>{__("sign_in")}
				</a>
				<a href="{"profiles.add"|fn_url}" rel="nofollow" class="reg-user-link"><span class="sprite-main signup-ico"></span>{__("register")}</a>
				{if $settings.Security.secure_storefront != "partial"}
					<div  id="login_block{$block.snapping_id}" class="hidden" title="{__("sign_in")}">
						<div class="ty-login-popup">
							{include file="views/auth/login_form.tpl" style="popup" id="popup`$block.snapping_id`"}
						</div>
					</div>
				{/if}
			{/if}
			<div id="dropdown_{$dropdown_id}" class="cm-popup-box ty-dropdown-box__content hidden">
				{$content|default:"&nbsp;" nofilter}
			</div>
		<!--wish_list_block--></div>
	</div>
{/if}
