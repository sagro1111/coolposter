{if $content|trim}
<div class="ip-content-grid homepage-on-sale">
    <div class="ty-mainbox-simple-container clearfix{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">
        {if $title || $smarty.capture.title|trim}
            <div class="main-box-title ip-product-card-head">
            <h2 class="ty-mainbox-title ip-product-title title-width-new light-grey-background">
                {hook name="wrapper:mainbox_simple_title"}
                {if $smarty.capture.title|trim}
                    {$smarty.capture.title nofilter}
                {else}
                    {$title nofilter}
                {/if}
                {/hook}
            </h2>
            <div class="post-title-card">для ваших картин на холсте, стекле и виниле</div>
            </div>
        {/if}
        <div class="ty-mainbox-body main-catalog-grid">{$content nofilter}</div>
    </div>
</div>
{/if}