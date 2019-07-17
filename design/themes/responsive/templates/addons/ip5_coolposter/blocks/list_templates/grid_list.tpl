
{if $products}
	
	{*
	<form action="{""|fn_url}" method="post" name="age_verification">
		<div class="ty-control-group">
			<div></div>
			<p><select size="3" name="type">
					<option value="photo">Фото</option>
					<option value="illustration">Иллюстрация</option>
					<option value="vector">Векторное изображение</option>
				</select></p>
			<div>Ориентация</div>
			<p><select size="3" name="orientation">
					<option value="horizontal">Горизонтальная</option>
					<option value="vertical">Вертикальная</option>
				</select></p>

			<input type="hidden" name="category" value="{$_REQUEST['category']}">
		</div
		<div class="buttons-container">
			{include file="buttons/button.tpl" but_role="submit" but_text="поиск" but_name="dispatch[catalog.view]" but_meta="ty-btn__secondary"}
		</div>
	</form>
	*}
	
	
	
	
	{include file="common/previewer.tpl"}
	{script src="js/tygh/exceptions.js"}
	{include file="common/pagination.tpl"}

	{split data=$products size=$columns|default:"2" assign="splitted_products"}

	{math equation="100 / x" x=$columns|default:"2" assign="cell_width"}
	{if $item_number == "Y"}
		{assign var="cur_number" value=1}
	{/if}
	
	
	{script src="js/tygh/product_image_gallery.js"}   
    <div class="grid-list" data-category-id="{$search.category}">
				{strip}
            {foreach from=$splitted_products item="sproducts" name="sprod"}
                {foreach from=$sproducts item="product" name="sproducts"}
					<div class="ty-column{$columns}">
                       	 {if $product}
								<div class="ty-grid-list__item ty-quick-view-button__wrapper">
                                <div class="">
									{$src = $product.assets.large_thumb.url}
									{$preview = $product.assets.preview.url}
									<a	class="cm-image-previewer cm-previewer ty-previewer cool-zoom" 
										id="det_img_link_{$product.id}" 
										ca-image-width="604"
										data-ca-image-height="604"
										data-ca-image-id="preview[product_images_{$product.id}]"
										href="{$preview}">
										<span><i class="sprite-main button-zoom-ico"></i>{__("zoom_foto")}</span>
									</a>
								</div>
								
								<div class="ty-grid-list__image">
									<div class="list-inner__image"><img src="{$src}" class="ty-pict" alt="" /></div>
								</div>

								<div class="ty-grid-list__control">
									<div class="button-container">
										<button	data-image-id="{$product.id}" class="cool-buy ty-btn ty-btn__big">
											<span class="sprite-main button-cart-ico"></span> {__("choose")}
										</button>
									</div>
                                </div>
                            </div>
                        {/if}
                    </div>
                {/foreach}
            {/foreach}
        {/strip}
    </div>


	{include file="common/pagination.tpl"}

{/if}

{capture name="mainbox_title"}{$title}{/capture}