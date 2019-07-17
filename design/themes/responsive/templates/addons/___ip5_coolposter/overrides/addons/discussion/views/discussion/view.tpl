{assign var="discussion" value=$object_id|fn_get_discussion:$object_type:true:$smarty.request}
{if $object_type == "P"}

{$new_post_title = __("write_review")}
{else}
{$new_post_title = __("new_post")}
{/if}

{if $discussion && $discussion.type != "D"}
		<div class="leave-review-block clearfix">
			<div class="leave-review-left-block">В данном разделе вы можете поделиться благодарностью, огорчением, оставить отзыв или предложение.</div>
			<div class="leave-review-right-block clearfix">
				{* <a href="" class="ty-btn ty-btn__primary"><span class="write-ico"></span>Оставить отзыв</a> *}
				{if "CRB"|strpos:$discussion.type !== false && !$discussion.disable_adding}
            <div class="ty-discussion-post__buttons buttons-container">
                {include file="buttons/button.tpl" but_id="opener_new_post" but_text=$new_post_title but_role="submit" but_target_id="new_post_dialog_`$obj_id`" but_meta="cm-dialog-opener cm-dialog-auto-size ty-btn__primary" but_rel="nofollow"}
            </div>
            {if $object_type != "P"}
                {include file="addons/discussion/views/discussion/components/new_post.tpl" new_post_title=$new_post_title}
            {/if}
        {/if}
			</div>
		</div>
		
		
    <div class="discussion-block ty-mainbox-body ip-reviews-block" id="{if $container_id}{$container_id}{else}content_discussion{/if}">
        {if $wrap == true}
            {capture name="content"}
            {include file="common/subheader.tpl" title=$title}
        {/if}

        {if $subheader}
            <h4>{$subheader}</h4>
        {/if}

        <div id="posts_list_{$object_id}">
            {if $discussion.posts}
                {include file="common/pagination.tpl" id="pagination_contents_comments_`$object_id`" extra_url="&selected_section=discussion" search=$discussion.search}
                {foreach from=$discussion.posts item=post}
                    <div class="ty-discussion-post__content clearfix ty-mb-l">
                        {hook name="discussion:items_list_row"}
							<div class="ip-discussion-user">
							<span class="ty-discussion-post__author">{$post.name}</span>

							{if $discussion.type == "R" || $discussion.type == "B" && $post.rating_value > 0}
							<div class="ty-discussion-post__rating">
							{include file="addons/discussion/views/discussion/components/stars.tpl" stars=$post.rating_value|fn_get_discussion_rating}
							</div>
							{/if}
								<span class="ty-discussion-post__date">{$post.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</span>
							</div>
	                        
	                        <div class="ty-discussion-post {cycle values=", ty-discussion-post_even"}" id="post_{$post.post_id}">
	                            {if $discussion.type == "C" || $discussion.type == "B"}
	                                <div class="ty-discussion-post__message">{$post.message|escape|nl2br nofilter}</div>
	                            {/if}
	                        </div>

                        {/hook}
                    </div>
                {/foreach}


                {include file="common/pagination.tpl" id="pagination_contents_comments_`$object_id`" extra_url="&selected_section=discussion" search=$discussion.search}
            {else}
                <p class="ty-no-items">{__("no_posts_found")}</p>
            {/if}
        <!--posts_list_{$object_id}--></div>



        {if $wrap == true}
            {/capture}
            {$smarty.capture.content nofilter}
        {else}
            {capture name="mainbox_title"}{$title}{/capture}
        {/if}
    </div>
{/if}
