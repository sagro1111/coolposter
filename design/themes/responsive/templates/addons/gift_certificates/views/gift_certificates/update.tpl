{include file="common/price.tpl" value=$addons.gift_certificates.max_amount assign="max_amount"}
{include file="common/price.tpl" value=$addons.gift_certificates.min_amount assign="min_amount"}
{assign var="text_gift_cert_amount_alert" value=__("text_gift_cert_amount_alert", ["[min]" => $min_amount, "[max]" => $max_amount])}

<script type="text/javascript">
(function(_, $) {

    var max_amount = '{$addons.gift_certificates.max_amount|escape:javascript nofilter}';
    var min_amount = '{$addons.gift_certificates.min_amount|escape:javascript nofilter}';
    var send_via = '{$gift_cert_data.send_via|default:"E"}';

    $(document).ready(function() {

        $.ceFormValidator('registerValidator', {
            class_name: 'cm-gc-validate-amount',
            message: '',
            func: function(id) {
                var max = parseInt((parseFloat(max_amount) / parseFloat(_.currencies.secondary.coefficient))*100)/100;
                var min = parseInt((parseFloat(min_amount) / parseFloat(_.currencies.secondary.coefficient))*100)/100;

                var amount = parseFloat($('#' + id).val());
                if ((amount <= max) && (amount >= min)) {
                    return true;
                }

                return false;
            }
        });

        if ($('#send_via').val() == 'P') {
            send_via = 'P';
            $('#post_block').switchAvailability(false, true);
        } else {
            send_via = 'E';
            $('#email_block').switchAvailability(false, true);
        }

        $('#' + (send_via == 'E' ? 'post' : 'email') + '_block').switchAvailability(true, true);

        $(_.doc).on('click', 'input[name="gift_cert_data[send_via]"]', function() {
            if ($(this).val() == 'P') {
                $('#send_via').val('P');
            } else {
                $('#send_via').val('');
            }

            $('#email_block').switchAvailability($(this).val() == 'P', true);
            $('#post_block').switchAvailability($(this).val() == 'E', true);
        });
    });
}(Tygh, Tygh.$));
</script>

{include file="views/profiles/components/profiles_scripts.tpl"}

{** Gift certificates section **}
<div class="ty-gift-certificate">

{if !$config.tweaks.disable_dhtml && !$no_ajax && $runtime.mode != "update"}
    {assign var="is_ajax" value=true}
{/if}

<form {if $is_ajax}class="cm-ajax cm-ajax-full-render" {/if}action="{""|fn_url}" method="post" target="_self" name="gift_certificates_form">
{if $runtime.mode == "update"}
<input type="hidden" name="gift_cert_id" value="{$gift_cert_id}" />
<input type="hidden" name="type" value="{$type}" />
{/if}

{if $is_ajax}
<input type="hidden" name="redirect_url" value="{$config.current_url}" />
{/if}

<div class="ty-control-group">
    <label for="gift_cert_recipient" class="ty-control-group__title cm-required">{__("recipients_name")}</label>
    <input type="text" id="gift_cert_recipient" name="gift_cert_data[recipient]" class="ty-input-text-full cm-focus" size="50" maxlength="255" value="{$gift_cert_data.recipient}" />
</div>

<div class="ty-control-group">
    <label for="gift_cert_sender" class="ty-control-group__title cm-required">{__("purchasers_name")}</label>
    <input type="text" id="gift_cert_sender" name="gift_cert_data[sender]" class="ty-input-text-full" size="50" maxlength="255" value="{$gift_cert_data.sender}" />
</div>

<div class="ty-control-group ty-gift-certificate__amount">
    <label for="gift_cert_amount" class="ty-control-group__title cm-required cm-gc-validate-amount">{__("amount")}</label>
    <span class="ty-gift-certificate__currency">{$currencies.$secondary_currency.symbol nofilter}</span>
    <input type="text" id="gift_cert_amount" name="gift_cert_data[amount]" class="ty-gift-certificate__amount-input cm-numeric" data-p-sign="s" data-a-sep="" {if $currencies.$secondary_currency.decimals_separator}data-a-dec="{$currencies.$secondary_currency.decimals_separator}"{/if} size="5" value="{if $gift_cert_data}{$gift_cert_data.amount|fn_format_rate_value:"":$currencies.$secondary_currency.decimals:".":"":$currencies.$secondary_currency.coefficient}{else}{$addons.gift_certificates.min_amount|fn_format_rate_value:"":$currencies.$secondary_currency.decimals:".":"":$currencies.$secondary_currency.coefficient}{/if}" />
    
    <div class="ty-gift-certificate__amount-alert form-field-desc">{$text_gift_cert_amount_alert nofilter}</div>
</div>

<div class="ty-control-group">
    <label for="gift_cert_message" class="ty-control-group__title">{__("gift_comment")}</label>
    <textarea id="gift_cert_message" name="gift_cert_data[message]" cols="72" rows="4" class="ty-input-text-full" {if $is_text == "Y"}readonly="readonly"{/if}>{$gift_cert_data.message}</textarea>
</div>

{if $addons.gift_certificates.free_products_allow == "Y"}
    <div class="ty-gift-certificate__products ty-control-group">
        {include file="pickers/products/picker.tpl" data_id="free_products" item_ids=$gift_cert_data.products input_name="gift_cert_data[products]" type="table" no_item_text=__("text_no_products_defined") holder_name="gift_certificates" but_role="text" but_meta="ty-btn__tertiary" but_text=__("gift_add_products") no_container = true icon_plus = true}
    </div>
{/if}

<div class="ty-gift-certificate__switch clearfix">
    <div class="ty-gift-certificate__switch-label gift-send-right">{__("how_to_send")}</div>
    <div class="ty-gift-certificate__switch-mail">
        <input type="hidden" id="send_via" value="{$gift_cert_data.send_via}" />
        <div class="ty-gift-certificate__send">
            <input type="radio" name="gift_cert_data[send_via]" value="E" {if $runtime.mode == "add" || $gift_cert_data.send_via == "E"}checked="checked"{/if} class="radio" id="sw_gc_switcher_suffix_e" /><label for="sw_gc_switcher_suffix_e" class="ty-valign">{__("send_via_email")}</label>
        </div>
        <div class="ty-gift-certificate__send">
            <input type="radio" name="gift_cert_data[send_via]" value="P" {if $gift_cert_data.send_via == "P"}checked="checked"{/if} class="radio" id="sw_gc_switcher_suffix_p" /><label for="sw_gc_switcher_suffix_p" class="ty-valign">{__("send_via_postal_mail")}</label>
        </div>
    </div>
</div>

<div id="gc_switcher">

    <div class="ty-gift-certificate__block {if $gift_cert_data.send_via == "P"} hidden{/if}" id="email_block">
        <div class="ty-control-group">
            <label for="gift_cert_email" class="cm-required cm-email ty-control-group__title">{__("email")}</label>
            <input type="text" id="gift_cert_email" name="gift_cert_data[email]" class="ty-input-text-full" size="40" maxlength="128" value="{$gift_cert_data.email}" />
        </div>
        <div class="ty-control-group">
            {if $templates|sizeof > 1}
                <label for="gift_cert_template" class="ty-control-group__title">{__("template")}</label>
                <select id="gift_cert_template" name="gift_cert_data[template]">
                {foreach from=$templates item="name" key="file"}
                    <option value="{$file}" {if $file == $gift_cert_data.template}selected{/if}>{$name}</option>
                {/foreach}
                </select>
            {else}
                {foreach from=$templates item="name" key="file"}
                    <input id="gift_cert_template" type="hidden" name="gift_cert_data[template]" value="{$file}" />
                {/foreach}
            {/if}
        </div>
    </div>

    <div class="ty-gift-certificate__block{if $runtime.mode == "add" || $gift_cert_data.send_via == "E"} hidden{/if}" id="post_block">

        <div class="ty-control-group">
            <label for="gift_cert_phone" class="ty-control-group__title">{__("phone")}</label>
            <input type="text" id="gift_cert_phone" name="gift_cert_data[phone]" class="ty-input-text-full" size="50" value="{$gift_cert_data.phone}" />
        </div>

        <div class="ty-control-group">
            <label for="gift_cert_address" class="ty-control-group__title cm-required">{__("address")}</label>
            <input type="text" id="gift_cert_address" name="gift_cert_data[address]" class="ty-input-text-full" size="50" value="{$gift_cert_data.address}" />
        </div>

        <div class="ty-control-group">
            <input type="text" id="gift_cert_address_2" name="gift_cert_data[address_2]" class="ty-input-text-full" size="50" value="{$gift_cert_data.address_2}" />
        </div>

        <div class="ty-control-group">
            <label for="gift_cert_city" class="ty-control-group__title cm-required">{__("city")}</label>
            <input type="text" id="gift_cert_city" name="gift_cert_data[city]" class="ty-input-text-full" size="50" value="{$gift_cert_data.city}" />
        </div>

        {$_country = $gift_cert_data.country|default:$settings.General.default_country}
        <div class="ty-control-group ty-float-left ty-gift-certificate__country country">
            <label for="gift_cert_country" class="ty-control-group__title cm-required">{__("country")}</label>
            <select id="gift_cert_country" name="gift_cert_data[country]" class="ty-gift-certificate__select cm-country cm-location-billing" >
                <option value="">- {__("select_country")} -</option>
                {foreach from=$countries item="country" key="code"}
                <option {if $_country == $code}selected="selected"{/if} value="{$code}">{$country}</option>
                {/foreach}
            </select>
        </div>

        {$_state = $gift_cert_data.state|default:$settings.General.default_state}
        <div class="ty-control-group ty-float-right ty-gift-certificate__state state">
            <label for="gift_cert_state" class="ty-control-group__title cm-required">{__("state")}</label>
            <select class="ty-gift-certificate__select cm-state cm-location-billing" id="gift_cert_state" name="gift_cert_data[state]">
                <option value="">- {__("select_state")} -</option>
                {if $states && $states.$_country}
                    {foreach from=$states.$_country item=state}
                        <option value="{$state.code}" {if $_state == $state.code}selected="selected"{/if}>{$state.state}</option>
                    {/foreach}
                {/if}
            </select>
            <input type="text" id="gift_cert_state_d" name="gift_cert_data[state]" class="cm-state cm-location-billing ty-input-text hidden" size="50" maxlength="64" value="{$_state}" disabled="disabled"  />
        </div>

        <div class="ty-control-group ty-billing-zip-code">
            <label for="gift_cert_zipcode" class="ty-control-group__title cm-required cm-zipcode cm-location-billing">{__("zip_postal_code")}</label>
            <input type="text" id="gift_cert_zipcode" name="gift_cert_data[zipcode]" class="ty-input-text-full" size="50" value="{$gift_cert_data.zipcode}" />
        </div>

    </div>

</div>

<div class="ty-gift-certificate__buttons buttons-container">

{if $runtime.mode == "add"}
    <input type="hidden" name="result_ids" value="cart_status*,wish_list*,account_info*" />
    <input type="hidden" name="redirect_url" value="{$config.current_url}" />
    {hook name="gift_certificates:buttons"}
        {include file="buttons/add_to_cart.tpl" but_name="dispatch[gift_certificates.add]" but_role="action"}
    {/hook}
{else}
    {include file="buttons/save.tpl" but_name="dispatch[gift_certificates.update]"}
{/if}
{if $templates}
    <div class="ty-float-right ty-gift-certificate__preview-btn">
    {include file="buttons/button.tpl" but_text=__("preview") but_name="dispatch[gift_certificates.preview]" but_role="submit" but_meta="ty-btn__tertiary cm-new-window"}
    </div>
{/if}
</div>

</form>
</div>
{** / Gift certificates section **}

{capture name="mainbox_title"}{if $runtime.mode == "add"}{__("purchase_gift_certificate")}{else}{__("gift_certificate")}{/if}{/capture}
