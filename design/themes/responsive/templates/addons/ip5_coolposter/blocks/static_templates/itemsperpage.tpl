{* <div class="ty-sort-dropdown">
	<a 	id="sw_elm_pagination_steps" 
		class="ty-sort-dropdown__wrapper cm-combination">
		{$pagination.items_per_page} {__("per_page")}
		<i class="ty-sort-dropdown__icon ty-icon-down-micro"></i>
	</a>
	<ul id="elm_pagination_steps" class="ty-sort-dropdown__content cm-popup-box hidden">
		{foreach from=$product_steps item="step"}
		{if $step != $pagination.items_per_page}
			<li class="ty-sort-dropdown__content-item">
				<a 	class="{$ajax_class} ty-sort-dropdown__content-item-a" 
					href="{"`$range_url`&items_per_page=`$step`"|fn_url}" 
					data-ca-target-id="{$pagination_id}" 
					rel="nofollow">{$step} {__("per_page")}</a>
			</li>
		{/if}
		{/foreach}
	</ul>
</div>
*}

{assign var="pagination" value=$search|fn_generate_pagination}

{if $pagination.total_items}
	{*assign var="range_url" value=$curl|fn_query_remove:"items_per_page":"page"*}
	{assign	var="product_steps" 
			value=$settings.Appearance.columns_in_products_list|fn_get_product_pagination_steps:$settings.Appearance.products_per_page}
	<div class="search-result-count">
		<select id="cool_pager">
			{strip}
				{foreach from=$product_steps item="step"}
					<option	value="{$step}" {if $step == $pagination.items_per_page}selected{/if}>
						{$step} фото на страницу
					</option>
				{/foreach}
			{strip}
		</select>
	</div>
{/if}