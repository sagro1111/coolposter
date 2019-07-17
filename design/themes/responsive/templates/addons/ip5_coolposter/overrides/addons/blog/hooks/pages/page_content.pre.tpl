{if $page.description && $page.page_type == $smarty.const.PAGE_TYPE_BLOG}
    <div class="ty-blog__date">{$page.timestamp|date_format:"`$settings.Appearance.date_format`"}</div>
    <br /><br />
{/if}