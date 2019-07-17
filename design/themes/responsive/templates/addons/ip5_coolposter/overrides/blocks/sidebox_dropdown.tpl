<ul class="ip-menu-header line-border">

	<li class="sidebar__item skinPlank harmonica">
		<a class="menu-head-block clearfix toggle">
			<span class="menu-head-title">{$block['name']}</span>
			<span class="menu-head-burger"></span>
		</a>
		
		
	{if $runtime.controller == "index"}
		<ul class="side-menu-list inner show" style="display: block;">
	{else}
		<ul class="side-menu-list inner">
	{/if}

			<span class="space-list-head"></span>
			{if $items}

				{foreach from=$items item=item}
				
					{assign var="item_url" value=$item|fn_form_dropdown_object_link:$block.type}
					
					<li class="side-menu-item side-menu-hover">

						{if $item['parent_id']=='267'}
							<a 	{if $item_url} href="{$item_url}"{/if} {if $item.new_window}target="_blank"{/if} class="side-menu-link">{$item.$name}</a>
						{else}
							<a 	href="{"?dispatch=catalog.view&category=`$item.category_id`"|fn_url}" class="side-menu-link ">{$item.$name}</a>
							<span class="ip5_arrow_dropdown ty-icon-down-open toggle"></span>

						{/if}
						
						{if $item.$childs}
							<ul class="side-dropdown-menu inner">
								<div class="side-dropdown-box">
									{foreach from=$item.$childs item=subcategory}
										<li class="side-dropdown-item">

											<a 	class="side-dropdown-link"
												href="{"?dispatch=catalog.view&category=`$subcategory.category_id`"|fn_url}">
												{$subcategory.$name}</a>
										</li>
									{/foreach}
								</div>
							</ul>
						{/if}
						
					</li>
				{/foreach}
			{else}
				Нет категорий для отображения
			{/if}
		</ul>
	</li>

</ul>

