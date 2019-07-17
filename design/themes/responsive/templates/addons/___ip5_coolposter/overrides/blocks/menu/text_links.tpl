{** block-description:text_links **}

{if $block.properties.show_items_in_line == 'Y'}
    {assign var="inline" value=true}
{/if}

{assign var="text_links_id" value=$block.snapping_id}

{if $items}
	<ul class="ip-company-info">
		<span id="sw_text_links_{$text_links_id}" class="ty-text-links-btn cm-combination visible-phone">
			<i class="ty-icon-short-list"></i>
			<i class="ty-icon-down-micro ty-text-links-btn__arrow"></i>
		</span>

		{foreach from=$items item="menu"}
			<li class="ip-company-info-item {if $menu.subitems}dropdown-hover{/if}">
				<a {if $menu.href}href="{$menu.href|fn_url}"{/if}>
					<span>{$menu.item}</span>
					{if $menu.subitems}
						<span class="arrow-small-down-ico"></span>
					{/if}
				</a>

				{if $menu.subitems}
					<div class="ip-dropdown dropdown-company">
						{foreach from=$menu.subitems item="subitem"}
							<a {if $subitem.href}href="{$subitem.href|fn_url}"{/if}>
								<span>{$subitem.item}</span>
							</a>
						{/foreach}
					</div>
				{/if}
			</li>
		{/foreach}
	</ul>
{/if}
