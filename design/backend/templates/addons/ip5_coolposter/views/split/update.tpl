{if $category_id}
	{capture name="mainbox"}
		{if $split_data.split_id}
			{assign var="id" value=$split_data.split_id}
		{else}
			{assign var="id" value=0}
		{/if}

		<form 	id="update_split_form"
				action="{""|fn_url}"
				method="post"
				name="update_split_form"
				class="form-horizontal form-edit cm-disable-empty-files">
			<input 	type="hidden"
					name="split_id"
					value="{$id}" />
			<input 	type="hidden"
					name="split_data[category_id]"
					value="{$category_id}" />
			<input 	type="hidden"
					name="split_data[rectangles]"
					id="rectangles"
					value="{$split_data.rectangles}" />
			<div class="control-group">
				<a href="{"coolposter.update?category_id=`$category_id`"|fn_url}">{__("back")}</a>
			</div>

			<div class="poster-title">{include file="common/subheader.tpl" title=__("cool_split")}</div>

			<div class="control-group" id="cool_split">
				<div class="cool-admin">
					<canvas id='canvas'></canvas>
				</div>

				<a id="add-square" class="btn">{__("add_square")}</a>
				<a id="del-square" class="btn hidden">{__("del_square")}</a>

				<script>
					$(document).ready(function() {
						try {
							editor();
						} catch(err) {
							console.log(err);
						}
					});
				</script>
			</div>
			<h3><p>Ориентация разбиваемых изображений</p></h3>
			<div class="poster-orientation">
			<label><input type="radio" name="split_data[orientation]" value="v"> <span>Вертикальная</span></input></label>
			<label><input type="radio" name="split_data[orientation]" value="h"> <span>Горизонтальная</span></input></label>
			<label><input type="radio" name="split_data[orientation]" value="u"> <span>Универсальная</span></input></label>
			</div>
		</form>
	{/capture}

	{capture name="buttons"}
		{if $id}
			{capture name="tools_list"}
				<li>
					{btn	type="list"
							text=__("delete")
							class="cm-confirm cm-post"
							href="split.delete?split_id=`$id`"}
				</li>
			{/capture}
			{dropdown content=$smarty.capture.tools_list}
		{/if}
		{include	file="buttons/save.tpl"
					but_role="submit-link"
					but_name="dispatch[split.update]"
					but_target_form="update_split_form"
					save=$id}
	{/capture}

	{if $id}
		{capture name="mainbox_title"}
			{__("editing_split")}
		{/capture}
	{else}
		{capture name="mainbox_title"}
			{__("new_split")}
		{/capture}
	{/if}

	{include	file="common/mainbox.tpl"
				title=$smarty.capture.mainbox_title
				content=$smarty.capture.mainbox
				buttons=$smarty.capture.buttons}
{/if}
