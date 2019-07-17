<div id="breadcrumbs_{$block.block_id}">

    {if $breadcrumbs && $breadcrumbs|@sizeof > 1}
     {$switch=0}
        <div class="ty-breadcrumbs clearfix">
             {strip}
                {foreach from=$breadcrumbs item="bc" name="bcn" key="key"}
                    {if $bc['link']=="categories.view?category_id=266"}
                        {$switch=1}
                    {/if}
                    {if $switch==1}
                        {if $key != "0"}
                            <span class="ty-breadcrumbs__slash"></span>
                        {/if}
                        {if $bc.link}
                            <a href="{$bc.link|replace:'categories':'catalog'|replace:'category_id':'category'|fn_url}" class="ty-breadcrumbs__a{if $additional_class} {$additional_class}{/if}"{if $bc.nofollow} rel="nofollow"{/if}>{$bc.title|strip_tags|escape:"html" nofilter}</a>
                        {else}
                            <span class="ty-breadcrumbs__current">{$bc.title|strip_tags|escape:"html" nofilter}</span>
                        {/if}
                    {else}
                        {if $key != "0"}
                            <span class="ty-breadcrumbs__slash"></span>
                        {/if}
                        {if $bc.link}
                            <a href="{$bc.link|fn_url}" class="ty-breadcrumbs__a{if $additional_class} {$additional_class}{/if}"{if $bc.nofollow} rel="nofollow"{/if}>{$bc.title|strip_tags|escape:"html" nofilter}</a>
                        {else}
                            <span class="ty-breadcrumbs__current">{$bc.title|strip_tags|escape:"html" nofilter}</span>
                        {/if}
                    {/if}

                {/foreach}
                {include file="common/view_tools.tpl"}
            {/strip}
        </div>
    {/if}
    <!--breadcrumbs_{$block.block_id}--></div>
