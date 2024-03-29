{capture name="buttons"}
    <div class="ty-float-left">
        {include file="buttons/button.tpl" but_href="/index.php?dispatch=catalog.view&category=266" but_text=__("continue_shopping") but_meta="ty-btn__secondary cm-notification-close"}
    </div>

    <div class="ty-float-right">
    {if $settings.General.checkout_redirect == "Y"}
        {include file="buttons/button.tpl" but_meta="ty-btn__primary" but_text=__("view_cart") but_href="checkout.cart"}
    {else}
        {include file="buttons/checkout.tpl" but_href="checkout.checkout"}
    {/if}
    </div>

{/capture}
{capture name="info"}
    <div class="clearfix"></div>
    <hr class="ty-product-notification__divider" />

    <div class="ty-product-notification__total-info clearfix">
        <div class="ty-product-notification__amount ty-float-left"> {__("items_in_cart", [$smarty.session.cart.amount])}</div>
        <div class="ty-product-notification__subtotal ty-float-right">
            {__("cart_subtotal")} {include file="common/price.tpl" value=$smarty.session.cart.display_subtotal}
        </div>
    </div>
{/capture}
{include file="views/products/components/notification.tpl" product_buttons=$smarty.capture.buttons product_info=$smarty.capture.info}