{capture name="mainbox"}

	{if $category_data.category_id}
		{assign var="id" value=$category_data.category_id}
	{else}
		{assign var="id" value=0}
	{/if}

	<form 	id="update_category_form"
			action="{""|fn_url}"
			method="post"
			name="update_category_form"
			class="form-horizontal form-edit cm-disable-empty-files">
		<input type="hidden" name="category_id" value="{$id}" />

		<div class="control-group">
			<a href="{"coolposter.manage"|fn_url}" class="btn cm-back-link"><i class="exicon-back exicon-dark"></i> {__("all_categories")}</a>
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
		</div>

		{if $id}
			{include file="common/subheader.tpl" title=__("cool_splits") target="#acc_splits"}

			<div id="acc_splits" class="collapse in">
				<div class="control-group">
					<div class="controls">
						{foreach from=$splits item="split"}
							<div class="cool-wrapper">
								{assign var="canvas_id" value="canvas_`$split.split_id`"}
								<canvas id="{$canvas_id}"></canvas>
								
								{btn	type="list"
										text="E"
										class="cool-edit"
										href="split.update?split_id=`$split.split_id`"}
								{btn	type="list"
										text="D"
										class="cm-confirm cm-post cool-delete"
										href="split.delete?split_id=`$split.split_id`"}
								
								<script>
									$(document).ready(function() {
										try {
											canvas('{$canvas_id}', '{$split.rectangles}');
										} catch(err) {
											console.log(err);
										}
									});
								</script>
							</div>
						{/foreach}
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
						href="coolposter.delete?category_id=`$id`"}
			</li>
			<li>
				{btn	type="list"
						text=__("add_split")
						href="split.add?category_id=`$id`"}
			</li>
		{/capture}
		{dropdown content=$smarty.capture.tools_list}
	{/if}
	{include	file="buttons/save_cancel.tpl"
				but_role="submit-link"
				but_name="dispatch[coolposter.update]"
				but_target_form="update_category_form"
				save=$id}
{/capture}

{if $id}
	{capture name="mainbox_title"}
		{"{__("editing_category")}: `$category_data.name`"|strip_tags}
	{/capture}
{else}
	{capture name="mainbox_title"}
		{__("new_category")|strip_tags}
	{/capture}
{/if}

{include	file="common/mainbox.tpl"
			title=$smarty.capture.mainbox_title
			content=$smarty.capture.mainbox
			buttons=$smarty.capture.buttons}
