{if $smarty.session.cart.amount}
	<span class="sprite-main cart-ico ip-basket empty">
		<div class="ip-mount">{$smarty.session.cart.amount|default:0}</div>
	</span>
	<span class="ty-minicart-title empty-cart ty-hand">
		<span class="ty-block ty-minicart-title__header ip-cart-words">
			На сумму:  
			{include file="common/price.tpl" value=$smarty.session.cart.display_subtotal}
		</span>
	</span>
{else}
	<span class="sprite-main cart-ico ip-basket empty">
		<div class="ip-mount">{$smarty.session.cart.amount|default:0}</div>
	</span>
	<span class="ty-minicart-title empty-cart ty-hand">
		<span class="ty-block ty-minicart-title__header ip-cart-words">
			{__("cart_is_empty")}
		</span>
	</span>
{/if}