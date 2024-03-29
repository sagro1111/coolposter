{if $search}
	{if $products}
			{assign var="title_extra" value="{__("products_found")}: `$search.total_items`"}
			{assign var="layouts" value=""|fn_get_products_views:false:0}
			{if $category_data.product_columns}
				{assign var="product_columns" value=$category_data.product_columns}
			{else}
				{assign var="product_columns" value=$settings.Appearance.columns_in_products_list}
			{/if}
			{if $layouts.$selected_layout.template}
				{include file="`$layouts.$selected_layout.template`" columns=$product_columns show_qty=true no_sorting=true}
			{/if}
		{else}
			<p class="ty-no-items">{__("text_no_matching_products_found")}</p>
		{/if}
	{/if}

	{capture name="mainbox_title"}
		<span class="ty-mainbox-title__left">{$title}</span>
	{/capture}


