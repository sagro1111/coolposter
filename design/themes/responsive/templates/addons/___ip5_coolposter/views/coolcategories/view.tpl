<div id="products_search_{$block.block_id}">

	<div class="ty-mainbox-body">
		<div class="tags-block">
			<div class="tags-column">
				{if $items}

				{foreach from=$items[266]['subcategories'] item=item}
						<div class="tags-box clearfix">
					<div class="tags-left-block"><span></span></div>
					<div class="tags-right-block">
						<div class="tags-title">
							<a 	href="{"?dispatch=catalog.view&category=`$item['category_id']`&catpid=`$item["id_path"]`"|fn_url}"
													 class="side-menu-link">{$item['category']}
							</a>
						</div>
						<div class="tags-content">
							{foreach from=$item['subcategories'] item=subcategory}

								<a href="{"?dispatch=catalog.view&category=`$subcategory["category_id"]`&catpid=`$subcategory["id_path"]`"|fn_url}">{$subcategory["category"]}</a>
							{/foreach}
						</div>
					</div>
				</div>
				{/foreach}
				{/if}
			</div>
		</div>
	</div>

</div>