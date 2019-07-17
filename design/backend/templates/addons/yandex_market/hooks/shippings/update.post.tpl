
<div class="control-group">
    <label class="control-label" for="elm_ym_shipping_type">{__("yml_shipping_type")}</label>
    <div class="controls">
        <select name="shipping_data[yml_shipping_type]" id="elm_ym_shipping_type" >
            <option value=""> -- </option>
            {foreach from=$ym_shipping_types key=key item=name}
                <option value="{$key}" {if $shipping.yml_shipping_type == $key}selected="selected"{/if}>{$name}</option>
            {/foreach}
        </select>
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_ym_outlet_ids">{__("yml_shipping_outlets")}</label>
    <div class="controls">
        <input type="text" name="shipping_data[yml_outlet_ids]" id="elm_ym_outlet_ids" size="30" value="{$shipping.yml_outlet_ids}" class="input-large" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_yml_from_date">{__("yml_shipping_from_date")}</label>
    <div class="controls">
        <input type="text" name="shipping_data[yml_from_date]" id="elm_yml_from_date" size="30" value="{$shipping.yml_from_date}" class="input-medium" />
    </div>
</div>

<div class="control-group">
    <label class="control-label" for="elm_yml_to_date">{__("yml_shipping_to_date")}</label>
    <div class="controls">
        <input type="text" name="shipping_data[yml_to_date]" id="elm_yml_to_date" size="30" value="{$shipping.yml_to_date}" class="input-medium" />
    </div>
</div>
