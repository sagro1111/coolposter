{if $page.page_type == $smarty.const.PAGE_TYPE_BLOG}
	{if $subpages}

		<div class="ty-blog">
		
			{capture name="mainbox_title"}{__("blog")}{/capture}
			
			{include file="common/pagination.tpl"}

			{foreach from=$subpages item="subpage"}
			<div class="ty-blog__item ty-column2">
				<a href="{"pages.view?page_id=`$subpage.page_id`"|fn_url}" class="articles-link clearfix">
					<div class="ty-blog__description">
					
						<h2 class="ty-blog__post-title articles-head">{$subpage.page}</h2>
						
						<div class="ty-wysiwyg-content">
							<div class="articles-content-txt">
								{$subpage.spoiler nofilter}
								<div class="ty-blog__date ty-discussion-post__date">{$subpage.timestamp|date_format:"`$settings.Appearance.date_format`"}</div>
							</div>
						</div>
						
						
						
					</div>
				</a>
			</div>
			{/foreach}
			
			{include file="common/pagination.tpl"}

		</div>
		
		
	{/if}

	{if $page.description}
	    {capture name="mainbox_title"}<span class="ty-blog__post-title" {live_edit name="page:page:{$page.page_id}"}>{$page.page}</span>{/capture}
	{/if}

{/if}