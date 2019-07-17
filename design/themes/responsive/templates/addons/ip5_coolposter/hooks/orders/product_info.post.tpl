<a class="cm-dialog-opener cm-dialog-auto-size" style="font-weight: bold">Изображение разбивки</a><br>
<img class="hidden" src="{$order_info.product_groups.0.products[$product.item_id].main_pair.detailed.image_path}" id="p{$product.product_id}" title="Изображение разбивки"><br>
<strong>Shutterstock ID:</strong> {$product.extra.shutter}<br>
<strong>Разбивки и размер полотна:</strong><br>
{assign var="info" value=";"|explode:$product.extra.splits_info}
{foreach from=$info item=item}
{$item}<br>
{/foreach}
<strong>Материал:</strong> {$product.extra.material}<br>
<strong>Размеры:</strong> {$product.extra.size}<br>
<strong>Форма:</strong> {$product.extra.form}<br>