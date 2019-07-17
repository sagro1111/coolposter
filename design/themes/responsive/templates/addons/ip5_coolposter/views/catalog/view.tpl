{if $items}

	<div class="ty-mainbox-body">
		<div class="grid-list tags-block">
			
				{if $items}
					{foreach from=$items[266]['subcategories'] item=item}
						<div class="ty-column3 tags-box">
							<div class="ty-quick-view-button__wrapper">
							<div class="tags-right-block">
								<div class="tags-title">
									<a 	href="{"?dispatch=catalog.view&category=`$item['category_id']`"|fn_url}"
										  class="side-menu-link">{$item['category']}
									</a>
								</div>
								<div class="tags-content">
									{foreach from=$item['subcategories'] item=subcategory}

										<a href="{"?dispatch=catalog.view&category=`$subcategory["category_id"]`"|fn_url}">{$subcategory["category"]}</a>
									{/foreach}
								</div>
							</div>
							</div>
						</div>
					{/foreach}
				{/if}
				
				
		</div>
	</div>
	{hook name="products:search_results_mainbox_title"}
	
	
	
	{capture name="mainbox_title"}
		<language_variables>
			<item lang="ru" id="ty-mainbox-title">Категории фото для ваших картин</item>
		</language_variables>
	{/capture}
	{/hook}
{else}
	<div id="products_search_{$block.block_id}">
	
	<h1 class="ty-mainbox-title">Каталог фото {$category_data.category|trim} для вашей картины</h1>
	
	
		{if $subcategories}
			{math equation="ceil(n/c)" assign="rows" n=$subcategories|count c=$columns|default:"2"}
			{split data=$subcategories size=$rows assign="splitted_subcategories"}
			<ul class="subcategories clearfix">
				{foreach from=$splitted_subcategories item="ssubcateg"}
					{foreach from=$ssubcateg item=category name="ssubcateg"}
						{if $category}
							<li class="ty-subcategories__item">
								<a href="{"catalog.view?category=`$category.category_id`"|fn_url}">
									{if $category.main_pair}
										{include file="common/image.tpl"
										show_detailed_link=false
										images=$category.main_pair
										no_ids=true
										image_id="category_image"
										image_width=$settings.Thumbnails.category_lists_thumbnail_width
										image_height=$settings.Thumbnails.category_lists_thumbnail_height
										class="ty-subcategories-img"
										}
									{/if}
									<span {live_edit name="category:category:{$category.category_id}"}>{$category.category}</span>
								</a>
							</li>
						{/if}
					{/foreach}
				{/foreach}
			</ul>
		{/if}
	{if $products}

		{include 	file="addons/ip5_coolposter/blocks/list_templates/grid_list.tpl"
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
