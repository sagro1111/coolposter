{if $oi.extra.original}
	<p><strong>Оригинал изображения:</strong> <a href="{$oi.extra.original}">{$oi.main_pair.detailed.object_id}.jpg</a></p>
{/if}
<p><strong>Изображение разбивки:</strong> <a class="cm-dialog-opener cm-dialog-auto-size" data-ca-target-id="p{$oi.item_id}">{$oi.main_pair.detailed.object_id}.jpg</a></p>
<img src="{$oi.main_pair.detailed.image_path}" class="hidden" id="p{$oi.item_id}" title="Изображение разбивки">
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