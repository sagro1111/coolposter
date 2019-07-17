
<!--  begin info/form -->
<form name="image_form"
	action="{""|fn_url}"
	method="post"
	class="form-horizontal form-edit form-table"
	enctype="multipart/form-data">

{assign var="result_ids" value="product_categories"}

<h1 class="ty-mainbox-title">Загрузка фотографии для вашей картины</h1>




<div class="line-border">

<div class="row-fluid">
<div class="span8 left-load-col">
	<div class="drag-photo-block">
		<div class="drag-your-photo">
			<div class="drag-photo-info">
				<div class="text-load">Перетащите сюда фотографию <br>jpg, jpeg, png, bmp</div>
			
				{include file="common/fileuploader.tpl"
				var_name="cool_data[image]"}
				{include file="common/image_verification.tpl" option="coolposter"}
			</div>
		</div>
	</div>
  <div class="loading-line clearfix">
	<div class="loading-line-left">
		<input class="input-large-loading"  type="text" name="name" id="product_description_product" value="" placeholder="Введите название загружаемого фото">
		<input type="hidden" value="{$result_ids}" name="result_ids">
	</div>
	<div class="loading-line-right">
	
		<div class="ty-form-builder__buttons buttons-container">
			{include 	file="buttons/button.tpl"
			but_role="submit"
			but_text=__("submit")
			but_meta="ty-btn__secondary"
			but_name="dispatch[coolload.upload]"}
		</div>
	
	</div>
  </div>
</div>

<div class="span8 right-load-col">
<div class="info-block-img">
<h3>Вы сделали красивый снимок и хотите сделать из него картину? Или просто запечатлеть важное событие в жизни?</h3>
<p>Мы предлагаем Вам загрузить свое фото и сделать из него уникальную картину любого размера и в любом оформлении.  Внимание: формат загружаемого файла <span class="color-format">jpg, jpeg, png, bmp</span> максимальный размер <span class="color-format">30 Mb.</span> Размер фото должен быть не менее <span class="color-format">2000 px</span> по меньшей стороне. Загрузка фото может занять продолжительное время, обязательно дождитесь окончания процесса!</p>
<p>Загруженная Вами фотография будет удалена автоматически через четыри недели после оформления заказа, либо через две недели после загрузки, если Вам не удалось оформить заказ на сайте.</p>
<p>После печати на стекле, холсте или виниле, даже обычный снимок вам покажется шедевром.<br>Вам обязательно понравится с нами работать.</p>
</div>

</div>
</div>

</div>



</form>
<!--  /end info/form -->
