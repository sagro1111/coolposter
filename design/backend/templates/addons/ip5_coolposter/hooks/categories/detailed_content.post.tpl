{include file="common/subheader.tpl" title="Coolposter" target="#ip5_coolposter_settings"}

<div id="ip5_coolposter_settings" class="in collapse">
	<div class="control-group cm-no-hide-input">
		<label for="facebook_obj_type" class="control-label">API Категория</label>
		<div class="controls">
			<input 	type="text" 
					name="category_data[coolcategory]" 
					id="elm_category_name" 
					size="55" 
					value="{$category_data.coolcategory}" 
					class="input-large" {if $is_trash}
					readonly="readonly"{/if} />
		</div>
	</div>
	<div class="control-group cm-no-hide-input">
		<label for="facebook_obj_type" class="control-label">API Запрос</label>
		<div class="controls">
			<input 	type="text" 
					name="category_data[coolquery]" 
					id="elm_category_name" 
					size="55" 
					value="{$category_data.coolquery}" 
					class="input-large" {if $is_trash}
					readonly="readonly"{/if} />
		</div>
	</div>
</div>