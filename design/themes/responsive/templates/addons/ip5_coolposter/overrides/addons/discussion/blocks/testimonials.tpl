{** block-description:discussion_title_home_page **}
{assign var="discussion" value=0|fn_get_discussion:"E":true:$block.properties}
{if $discussion && $discussion.type != "D" && $discussion.posts}
	{assign var="obj_prefix" value="`$block.block_id`000"}

		<div id="scroll_list_{$block.block_id}" class="ty-scroller-list">

			{foreach from=$discussion.posts item=post}
			<div class="ty-discussion-post__content">
				{hook name="discussion:items_list_row"}
				<a href="{"discussion.view?thread_id=`$discussion.thread_id`&post_id=`$post.post_id`"|fn_url}#post_{$post.post_id}">
					<div class="ty-discussion-post {cycle values=", ty-discussion-post_even"}" id="post_{$post.post_id}">

						<span class="ty-discussion-post__author">{$post.name}</span>
						{if $discussion.type == "R" || $discussion.type == "B" && $post.rating_value > 0}
							<div class="clearfix ty-discussion-post__rating">
							{include file="addons/discussion/views/discussion/components/stars.tpl" stars=$post.rating_value|fn_get_discussion_rating}
							</div>
						{/if}
						<span class="ty-discussion-post__date">{$post.timestamp|date_format:"`$settings.Appearance.date_format`"}</span>
						<div class="clearfix"></div>
						{if $discussion.type == "C" || $discussion.type == "B"}
							<div class="ty-discussion-post__message">{$post.message|truncate:250|nl2br nofilter}</div>
						{/if}

					</div>
				</a>


				{/hook}
			</div>
			{/foreach}

		</div>
		<div class="view-all-block">
			<a href="{"discussion.view?thread_id=`$discussion.thread_id`&post_id=`$post.post_id`"|fn_url}#post_{$post.post_id}" class="ty-btn ty-btn__secondary">Посмотреть все отзывы</a>
		</div>
{/if}
