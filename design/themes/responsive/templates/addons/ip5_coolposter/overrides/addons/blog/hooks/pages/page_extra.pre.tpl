{if $page.page_type == $smarty.const.PAGE_TYPE_BLOG}

{if $subpages}

    {capture name="mainbox_title"}{__("blog")}{/capture}

    <div class="ty-blog">
        {include file="common/pagination.tpl"}

        {foreach from=$subpages item="subpage"}
            <div class="ty-blog__item ty-column2">
                <a href="{"pages.view?page_id=`$subpage.page_id`"|fn_url}">
                    <h3 class="ty-blog__post-title">{$subpage.page}</h3>
                </a>
                
                <div class="ty-blog__date">{$subpage.timestamp|date_format:"`$settings.Appearance.date_format`"}</div>
                
                {if $subpage.main_pair}
                <a href="{"pages.view?page_id=`$subpage.page_id`"|fn_url}">
                    <div class="ty-blog__img-block">
                        {include file="common/image.tpl" obj_id=$subpage.page_id images=$subpage.main_pair}
                    </div>
                </a>
                {/if}
                <div class="ty-blog__description">
                    <div class="ty-wysiwyg-content">
                        <div>{$subpage.spoiler|truncate:350 nofilter}</div>
                    </div>
                </div>
            </div>
        {/foreach}

        {include file="common/pagination.tpl"}
    </div>

{/if}

{if $page.description}
    {capture name="mainbox_title"}<span class="ty-blog__post-title" {live_edit name="page:page:{$page.page_id}"}>{$page.page}</span>{/capture}
{/if}

{/if}