{if $content|trim}
    <div class="ty-mainbox-container clearfix{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $details_page} details-page{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">
        {if $title || $smarty.capture.title|trim}
            {hook name="wrapper:mainbox_general_title_wrapper"}
              <div class="ip-mainbox-title review">
                <h3 class="ty-mainbox-title">
                    {hook name="wrapper:mainbox_general_title"}
                    {if $smarty.capture.title|trim}
                        <span>{$smarty.capture.title nofilter}</span>
                    {else}
                        <span>{$title nofilter}</span>
                    {/if}
                    {/hook}
                </h3>
              </div>
            {/hook}
        {/if}
        <div class="ty-mainbox-body">{$content nofilter}</div>
    </div>
{/if}