{if $settings_data}
    {capture name="mainbox"}
        <form 	id="update_setting_form"
                 action="{""|fn_url}"
                 method="post"
                 name="update_setting_form"
                 class="form-horizontal form-edit cm-disable-empty-files">
            <input 	type="hidden"
                      name="setting_id"
                      value="{'1'}" />
                      
                      
<br><br> 
<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Стоимость изображения:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[pict_cost]" value="{$settings_data['pict_cost']}"/></div>
	</div>
</div>

<hr>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Подготовка макета:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[maket]" value="{$settings_data['maket']}"/></div>
	</div>
</div>

<hr>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Cтоимость кв. метра печати на пластике:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[sm_plast]" value="{$settings_data['sm_plast']}"/></div>
	</div>
</div>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Стоимость погонного метра профиля при печати на пластике:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[profile_cost]" value="{$settings_data['profile_cost']}"/></div>
	</div>
</div>

<hr>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Cтоимость кв метра печати на холсте:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[sm_canvas]" value="{$settings_data['sm_canvas']}"/></div>
	</div>
</div>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Стоимость погонного метра подрамника при печати на холсте:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[stretcher_cost]" value="{$settings_data['stretcher_cost']}"/></div>
	</div>
</div>

<hr>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Cтоимость кв. метра печати на акриле (орг.стекле):</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[sm_plexiglass]" value="{$settings_data['sm_plexiglass']}"/></div>
	</div>
</div>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Стоимость кв метра печати на силикатном стекле:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[sm_slglass]" value="{$settings_data['sm_slglass']}"/></div>
	</div>
</div>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Комплект держателей при печати на стекле:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[holder_cost]" value="{$settings_data['holder_cost']}"/></div>
	</div>
</div>

<hr>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Уголок подрамника:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[stretcher_angle]" value="{$settings_data['stretcher_angle']}"/></div>
	</div>
</div>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Стоимость лакировки:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[varnish_cost]" value="{$settings_data['varnish_cost']}"/></div>
	</div>
</div>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Комплект крепежа на модуль:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[fastener_cost]" value="{$settings_data['fastener_cost']}"/></div>
	</div>
</div>

<hr>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Обработка торца акрила:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[obr_akril]" value="{$settings_data['obr_akril']}"/></div>
	</div>
</div>

<div class="control-group setting-wide yandex_market ">
	<label for="addon_option_yandex_market_export_type" class="control-label ">Обработка торца силиката:</label>
	<div class="controls">
		<div class="left update-for-all"><input type="text" name="setting_data[obr_silikat]" value="{$settings_data['obr_silikat']}"/></div>
	</div>
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
        but_name="dispatch[calc.update]"
        but_target_form="update_setting_form"
        save=$id}
    {/capture}

    {if $id}
        {capture name="mainbox_title"}
            {__("editing_split")}
        {/capture}
    {else}
        {capture name="mainbox_title"}
            {__("cool_calc")}
        {/capture}
    {/if}

    {include	file="common/mainbox.tpl"
    title=$smarty.capture.mainbox_title
    content=$smarty.capture.mainbox
    buttons=$smarty.capture.buttons}
{/if}
