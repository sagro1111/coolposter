<hr>
<p><a href="{$order_info.product_groups.0.products[$oi.item_id].main_pair.detailed.image_path}">Изображение разбивки</a></p>
<p><strong>Shutterstock ID:</strong> {$oi.extra.shutter}</p>
<p><strong>Разбивки и размер полотна:</strong><br>
{assign var="info" value=";"|explode:$oi.extra.splits_info}
{foreach from=$info item=item}
{$item}<br>
{/foreach}</p>
<p><strong>Материал:</strong> {$oi.extra.material}</p>
<p><strong>Размеры:</strong> {$oi.extra.size}</p>
<p><strong>Форма:</strong> {$oi.extra.form}</p>
<p><strong>Держатели:</strong> {$oi.extra.holder}</p>