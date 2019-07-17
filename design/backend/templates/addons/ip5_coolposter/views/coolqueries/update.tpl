{capture name="mainbox"}

	{if $category_data.query_id}
		{assign var="id" value=$category_data.query_id}
	{else}
		{assign var="id" value=0}
	{/if}

	{if $category_data.parent_id}
		{assign var="parent_id" value=$category_data.parent_id}
	{else}
		{assign var="parent_id" value=0}
	{/if}

	<form 	id="update_category_form"
			action="{""|fn_url}"
			method="post"
			name="update_category_form"
			class="form-horizontal form-edit cm-disable-empty-files">
		<input type="hidden" name="query_id" value="{$id}" />
		<input type="hidden" name="parent_id" value="{$parent_id}" />
		
		<div class="control-group">
			{if !$parent_id}
				<a href="{"coolqueries.manage"|fn_url}">{__("all_queries")}</a>
			{else}
				<a href="{"coolqueries.update?query_id=`$parent_id`"|fn_url}">{__("back")}</a>
			{/if}
		</div>

		{include file="common/subheader.tpl" title=__("information") target="#acc_information"}

		<div id="acc_information" class="collapse in">
			<div class="control-group">
				<label for="name" class="control-label cm-required">{__("name")}</label>
				<div class="controls">
					<input	class="input-large"
							type="text"
							name="category_data[name]"
							id="category_name"
							value="{$category_data.name}" />
				</div>
			</div>
			<div class="control-group">
				<label for="name" class="control-label">{__("shutter_category")}</label>
				<div class="controls">
					<input	class="input-large"
							type="text"
							name="category_data[category]"
							id="category_name"
							value="{$category_data.category}" />
				</div>
			</div>
			<div class="control-group">
				<label for="name" class="control-label">{__("shutter_query")}</label>
				<div class="controls">
					<input	class="input-large"
							type="text"
							name="category_data[query]"
							id="category_name"
							value="{$category_data.query}" />
				</div>
			</div>
		</div>

		{if $id && $parent_id == 0}
			{include file="common/subheader.tpl" title=__("sub_categories") target="#acc_splits"}

			<div id="acc_splits" class="collapse in">
				<div class="control-group" id="cool_subqueries">
					<label class="control-label">{__("sub_categories")}</label>
					<div class="controls">
						{if $category_data.subcategories}
							{include 
								file="addons/ip5_coolposter/views/coolqueries/components/subqueries.tpl"
								subcategories=$category_data.subcategories}
						{else}
							<p class="no-items">{__("no_data")}</p>
						{/if}
					</div>
				</div>
			</div>
		{/if}
	</form>

{/capture}

{capture name="buttons"}
	{if $id}
		{capture name="tools_list"}
			<li>
				{btn	type="list"
						text=__("delete")
						class="cm-confirm cm-post"
						href="coolqueries.delete?query_id=`$id`"}
			</li>
			{if $parent_id == 0}
				<li>
					{btn	type="list"
							text=__("add_subquery")
							href="coolqueries.add?query_id=`$id`"}
				</li>
			{/if}
		{/capture}
		{dropdown content=$smarty.capture.tools_list}
	{/if}
	{if $parent_id == 0}
		{include	file="buttons/save_cancel.tpl"
					but_role="submit-link"
					but_name="dispatch[coolqueries.update]"
					but_target_form="update_category_form"
					save=$id}
	{else}
		{include	file="buttons/save.tpl"
					but_role="submit-link"
					but_name="dispatch[coolqueries.update]"
					but_target_form="update_category_form"
					save=$id}
	{/if}
{/capture}

{if $id}
	{capture name="mainbox_title"}
		{if $parent_id == 0}
			{"{__("editing_category_query")}: `$category_data.name`"|strip_tags}
		{else}
			{"{__("editing_query")}: `$category_data.name`"|strip_tags}
		{/if}
	{/capture}
{else}
	{capture name="mainbox_title"}
		{if $parent_id == 0}
			{__("new_category_query")|strip_tags}
		{else}
			{__("new_query")|strip_tags}
		{/if}
	{/capture}
{/if}

{include	file="common/mainbox.tpl"
			title=$smarty.capture.mainbox_title
			content=$smarty.capture.mainbox
			buttons=$smarty.capture.buttons}
