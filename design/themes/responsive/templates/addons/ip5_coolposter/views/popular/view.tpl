

{if $search}
		{if $products}



			{include 	file="addons/ip5_coolposter/blocks/list_templates/grid_list_popular.tpl"
			show_trunc_name=true
			show_old_price=false
			show_price=true
			show_rating=false
			show_clean_price=true
			show_list_discount=false
			show_add_to_cart=true
			but_role="action"
			show_discount_label=false
			show_qty=false
			columns=$settings.Appearance.columns_in_products_list
			}
		{else}
			{hook name="products:search_results_no_matching_found"}
				<p class="ty-no-items">
					{strip}
						По вашему запросу: {$search.display} ничего не найдено
					{/strip}
				</p>
			{/hook}
		{/if}

		<!--products_search_{$block.block_id}--></div>

		{hook name="products:search_results_mainbox_title"}
		{capture name="mainbox_title"}
			{("Каталог фото")}: {$search.display}
		{/capture}
		{/hook}
{/if}

