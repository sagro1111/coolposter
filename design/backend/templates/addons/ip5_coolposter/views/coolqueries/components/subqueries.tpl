{include	file="common/pagination.tpl"
			save_current_page=true
			save_current_url=true
			div_id=$smarty.request.content_id}
{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{assign var="rev" value=$smarty.request.content_id|default:"pagination_contents"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}
<table width="100%" class="table table-middle">
	<thead>
		<tr>
			<th class="left" width="5%">
				{include file="common/check_items.tpl"}
			</th>
			<th width="5%">
				<a 	class="cm-ajax"
					href="{"`$c_url`&sort_by=id&sort_order=`$search.sort_order_rev`"|fn_url}"
					data-ca-target-id={$rev}>
					{__("id")}
					{if $search.sort_by == "id"}
						{$c_icon nofilter}
					{else}
						{$c_dummy nofilter}
					{/if}
				</a>
			</th>
			<th>
				<a 	class="cm-ajax"
					href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}"
					data-ca-target-id={$rev}>
					{__("category")}
					{if $search.sort_by == "name"}
						{$c_icon nofilter}
					{else}
						{$c_dummy nofilter}
					{/if}
				</a>
			</th>
			<th>
				<a 	class="cm-ajax"
					href="{"`$c_url`&sort_by=category&sort_order=`$search.sort_order_rev`"|fn_url}"
					data-ca-target-id={$rev}>
					{__("category")}
					{if $search.sort_by == "category"}
						{$c_icon nofilter}
					{else}
						{$c_dummy nofilter}
					{/if}
				</a>
			</th>
			<th width="10%">&nbsp;</th>
		</tr>
	</thead>
	<tbody>
		{foreach from=$subcategories item="category"}
			<tr>
				<td class="left" width="5%">
					<input 	type="checkbox"
							name="category_ids[]"
							value="{$category.query_id}"
							class="checkbox cm-item" />
				</td>
				<td width="5%">
					<a 	class="cm-tooltip"
						title="{$category.name}"
						href="{"coolposter.update?category_id=`$category.query_id`"|fn_url}">
						<strong>#{$category.query_id}</strong>
					</a>
				</td>
				<td>
					<input 	type="text"
							name="category_data[subcategories][{$category.query_id}][name]"
							size="20"
							maxlength="32"
							value="{$category.name}"
							class="input-hidden" />
				</td>
				<td>
					<input 	type="text"
							name="category_data[subcategories][{$category.query_id}][category]"
							size="20"
							maxlength="32"
							value="{$category.category}"
							class="input-hidden" />
				</td>
				<td class="nowrap">
					<div class="hidden-tools">
						{capture name="tools_list"}
							<li>{btn 	type="list"
										text=__("edit")
										href="coolqueries.update?query_id=`$category.query_id`"}
							</li>
							<li>{btn 	type="list"
										text=__("delete")
										class="cm-confirm cm-post"
										href="coolqueries.delete?parent_id=`$category.parent_id`&query_id=`$category.query_id`"}
							</li>
						{/capture}
						{dropdown content=$smarty.capture.tools_list}
					</div>
				</td>
			</tr>
		{/foreach}
	</tbody>
</table>

<div class="clearfix">
	{include file="common/pagination.tpl" div_id=$smarty.request.content_id}
</div>