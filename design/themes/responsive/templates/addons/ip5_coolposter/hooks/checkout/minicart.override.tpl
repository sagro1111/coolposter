{* *** hook name="checkout:minicart"  *** *}

<div class="cm-cart-content {if $block.properties.products_links_type == "thumb"}cm-cart-content-thumb{/if} {if $block.properties.display_delete_icons == "Y"}cm-cart-content-delete{/if}">
<div class="ty-cart-items clearfix">
    {if $smarty.session.cart.amount}
        <ul class="ty-cart-items__list">
            {hook name="index:cart_status"}
                {assign var="_cart_products" value=$smarty.session.cart.products|array_reverse:true}
                {foreach from=$_cart_products key="key" item="product" name="cart_products"}
                    {hook name="checkout:minicart_product"}
                    {if !$product.extra.parent}
                        <li class="ty-cart-items__list-item">
                            {hook name="checkout:minicart_product_info"}
                            {if $block.properties.products_links_type == "thumb"}
                                <div class="ty-cart-items__list-item-image">
                                    {include file="common/image.tpl" image_width="80" image_height="80" images=$product.main_pair no_ids=true}
                                </div>
                            {/if}
                            <div class="ty-cart-items__list-item-desc">
                                <a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{$product.product_id|fn_get_product_name nofilter}</a>
                            <p>
                                <span>{$product.amount}</span><span>&nbsp;x&nbsp;</span>{include file="common/price.tpl" value=$product.display_price span_id="price_`$key`_`$dropdown_id`" class="none"}
                            </p>
                            </div>
                            {if $block.properties.display_delete_icons == "Y"}
                                <div class="ty-cart-items__list-item-tools cm-cart-item-delete">
                                    {if (!$runtime.checkout || $force_items_deletion) && !$product.extra.exclude_from_calculate}
                                        {include file="buttons/button.tpl" but_href="checkout.delete.from_status?cart_id=`$key`&redirect_url=`$r_url`" but_meta="cm-ajax cm-ajax-full-render" but_target_id="cart_status*" but_role="delete" but_name="delete_cart_item"}
                                    {/if}
                                </div>
                            {/if}
                            {/hook}
                        </li>
                    {/if}
                    {/hook}
                {/foreach}
            {/hook}
        </ul>
    {else}
        <div class="ty-cart-items__empty ty-center">
			<span class="title-empty-cart cls">В Вашей корзине еще нет картин</span>
			<div class="content-empty-cart cls"><strong>Cоздайте свою картину!</strong><br />
			Выберите с <a href="index.php?dispatch=catalog.view&category=266" class="catalog-img-cart cls">каталога фото</a> или <a href="/coolload" class="load-img-cart cls">загрузите свое изображение</a></div>
        </div>
    {/if}
</div>

{if $block.properties.display_bottom_buttons == "Y"}
	<div class="cm-cart-buttons ty-cart-content__buttons buttons-container{if $smarty.session.cart.amount} full-cart{else} hidden{/if}">
	    <div class="ty-float-left"><a href="{"checkout.cart"|fn_url}" rel="nofollow" class="ty-btn ty-btn__secondary">{__("view_cart")}</a></div>
	    {if $settings.General.checkout_redirect != "Y"}
	    	<div class="ty-float-right"><a href="{"checkout.checkout"|fn_url}" rel="nofollow" class="ty-btn ty-btn__primary">{__("checkout")}</a></div>
	    {/if}
	</div>
{/if}
</div>