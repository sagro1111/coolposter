{if $capture_link}
    {capture name="link"}
{/if}

{if $show_brackets}({/if}
<a 	id="opener_{$id}" 
	class="cm-dialog-opener cm-dialog-auto-size {$link_meta}" {if $href}
	href="{$href|fn_url}"{/if} 
	data-ca-target-id="content_{$id}" {if $edit_onclick}
	onclick="{$edit_onclick}"{/if} 
	rel="nofollow">
	{if $link_icon}<i class="{$link_icon}"></i>{/if}
	<span class="ip-callback">{$link_text nofilter}</span>
</a>
{if $show_brackets}){/if}

{if $capture_link}
    {/capture}
{/if}

{if $content || $href || $edit_picker}
<div class="hidden{if $wysiwyg} ty-wysiwyg-content{/if}" id="content_{$id}" title="{$text}">
    {$content nofilter}
</div>
{/if}