{if ($product['coolimage'] || $product['return_period']=='900')}

{assign var="obj_id" value=$product.product_id}
{include file="common/product_data.tpl"
product=$product
but_role="big"
but_text=""
but_onclick="saveAll()"
show_add_to_cart=true}

<!-- begin page title -->
<div class="inner-box-title ip-catalog-title">
	<h1 class="ty-mainbox-title">Закажите свою картину на холсте, стекле или виниле</h1>
</div>
<!-- /end page title -->



<!--  begin make product -->
<div class="row-fluid">
	<div class="span16 top-line line-border">
		
		<!-- form old -->
		{assign var="form_open" value="form_open_`$obj_id`"}
		{$smarty.capture.$form_open nofilter}

		<div class="make-picture-block">
			<div class="make-picture-block-left">
				<div class="make-picture-title">Выберите форму:</div>

				<div class="choose-form-list-block">
					<ul class="choose-form-list">
					</ul>
				</div>
				<div class="make-picture-title">Управление:</div>
				<div class="make-picture-options">
					<!--<button class="picture-options-btn" id="unlock-button"><span class="lock-ico"></span>Разблокировать</button>
					<div class="controller-info-unlock">Теперь все доступные шаблоны разблокированы</div>
					<div class="picture-options-buttons">
						<button class="picture-options-btn-prev" disabled="disabled"><span></span> назад</button>
						<button class="picture-options-btn-next" disabled="disabled">вперед <span></span></button>
					</div>-->
					<!-- div class="slipper-block">
						<div class="controller-info">Масштаб: 0 - <span>16</span> см</div>
						<div class="slipper">
							<input type="range" min="1" max="20" value="1" id="scale-slipper" disabled="disabled">
						</div>
					</div -->
					
					<button class="picture-options-btn move-group-action" data-active="true"><span class="move-pic"></span>Двигать разбивку</button>
					
					
				</div>
			</div>
			<div class="make-picture-block-center">
				<div class="picture-block">
					<canvas id="canvas" class="picture-block-canvas" width="660" height="660"></canvas>
				</div>
				<div class="picture-block-info">
					
					<div class="slipper-block">
						<div class="slipper">
							<input type="range" min="1" max="20" value="1" id="scale-slipper" step="0.05" disabled="disabled">
						</div>
						<div class="controller-info">Масштаб: 0 - <span>16</span> см</div>
					</div>
					
					
					<div class="picture-block-options">
						<div class="picture-block-txt">Форма: <span id="templpate-value">Простая</span></div>
						<div class="picture-block-txt">Размер изделия: <span id="size-value">Вычисляем...</span></div>
						<!-- div class="picture-block-txt">Фактическая площадь: <span id="size-value-real" style="display: inline;"></span></div -->
						<div class="picture-block-txt">Материал: <span id="material-value">Стекло</span></div>
					</div>

					<div class="price-order">
						<div class="price-picture">
							<span class="picture-price-name">Цена:</span>
							<span class="picture-price-number" data-type="2" id="price">0</span>
							<span class="ty-sub-price"><span class="ty-rub">Р</span></span>
						</div><!-- form old -->
						{* include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text" *}
						<input type="hidden" name="product_data[{$obj_id}][price]" id="price-val" />
						<input type="hidden" name="product_data[{$obj_id}][size]" id="size-data" />
						<input type="hidden" name="product_data[{$obj_id}][form]" id="form-name" />
						<input type="hidden" name="product_data[{$obj_id}][splits]" id="splits-coord" />
						<input type="hidden" name="product_data[{$obj_id}][splits_info]" id="splits-info" />
						<input type="hidden" name="product_data[{$obj_id}][splits_img]" id="splits-img" />
						<input type="hidden" name="product_data[{$obj_id}][material]" id="material-val" />
						<input type="hidden" name="product_data[{$obj_id}][glass-id]" id="glass-id" value="0" />
						<input type="hidden" name="product_data[{$obj_id}][glass-type]" id="glass-type" value="" />
						<input type="hidden" name="product_data[{$obj_id}][shutter]" id="shutter" value="" />
						<div id="tigr-bottom">
							{assign var="incart" value=true}
							{foreach from=$smarty.session.cart.products item=i}
								{if $i.product_id == $product.product_id}
									{assign var="incart" value=false}
								{/if}
							{/foreach}
							{if $incart}
							<div id="cool-buy">
								{assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
								{$smarty.capture.$add_to_cart nofilter}
							</div>
							{else}
							<div id="cool-buy">
								{include file="buttons/button.tpl" but_id=$but_id but_text=$but_text|default:__("cart") but_name=$but_name but_href='/cart.html' but_meta="ty-btn__primary ty-btn__big ty-btn__add-to-cart"}
							</div>
							{/if}
						</div><!-- form old -->
					</div>
					
					<div class="clearfix"></div>
					
					<div class="picture-info-bottom">
						<div class="picture-block-txt shuter-foot">Код: <span>{$product['coolimage']}</span></div>
						<div class="picture-info-bottom-info">Вашу картину изготовим без знаков: <img src="/design/themes/responsive/media/images/addons/ip5_coolposter/logo-shuter.png" alt=""></div>
					</div>
				</div>
			</div>
			<div class="make-picture-block-right">
				<div class="make-picture-title">Выберите материал:</div>
				<ul class="choose-material-list skinPlank">
					
					<li class="choose-material-item sidebar__item">
						<a href="" class="choose-material-link" data-type="1" data-material="Винил">Печать на виниле</a>
						<ul class="dropdown-material-list">
							<li>
								<div class="holder-checkbox">
									<div>
										<label for="plastic1" class="custom-label"><input class="placeholder-type" name="product_data[{$obj_id}][plastic]" id="plastic1" data-type="Покрытие" type="radio" value="Мат" checked><i></i> Мат</label>
									</div>
									<div>
										<label class="custom-label" for="plastic2"><input class="placeholder-type"  name="product_data[{$obj_id}][plastic]" id="plastic2" data-type="Покрытие" type="radio"  value="Глянец"><i></i> Глянец</label>
									</div>
								</div>
								<div class="holder-checkbox">
									<h4>Рамка</h4>
									<div>
										<label for="ramka1" class="custom-label"><input class="placeholder-type" name="product_data[{$obj_id}][ramka]" id="ramka1" data-type="Рамка" type="radio" value="Серебро" checked><i></i> Серебро</label>
									</div>
									<div>
										<label for="ramka2" class="custom-label"><input class="placeholder-type" name="product_data[{$obj_id}][ramka]" id="ramka2" data-type="Рамка" type="radio" value="Золото"><i></i> Золото</label>
									</div>
									<div>
										<label for="ramka3" class="custom-label"><input class="placeholder-type" name="product_data[{$obj_id}][ramka]" id="ramka3" data-type="Рамка" type="radio" value="Черная"><i></i> Черная</label>
									</div>
									<div>
										<label for="ramka4" class="custom-label"><input class="placeholder-type" name="product_data[{$obj_id}][ramka]" id="ramka4" data-type="Рамка" type="radio" value="Белая"><i></i> Белая</label>
									</div>
									<div>
										<label for="ramka5" class="custom-label"><input class="placeholder-type" name="product_data[{$obj_id}][ramka]" id="ramka5" data-type="Рамка" type="radio" value="Без рамки"><i></i> Без рамки</label>
									</div>
								</div>
								<div class="material-txt">
									{__("pechat_text_vinil")}
								</div>
							</li>
						</ul>
					</li>

					<li class="choose-material-item sidebar__item">
						<a href="" class="choose-material-link"  data-type="2" data-material="Холст">Печать на холсте</a>
						<ul class="dropdown-material-list">
							<li>
								<div class="holder-checkbox">
									<h4>Покрытие</h4>
									<div>
										<label for="holst_varnish1" class="custom-label"><input class="placeholder-type" name="product_data[{$obj_id}][varnish]" id="holst_varnish1" data-type="Покрытие" type="radio" value="Без лака" checked><i></i> Без лака</label>
									</div>
									<div>
										<label class="custom-label" for="holst_varnish2"><input class="placeholder-type"  name="product_data[{$obj_id}][varnish]" id="holst_varnish2" data-type="Покрытие" type="radio" value="Лак"><i></i> Лак</label>
									</div>
								</div>
								<div class="material-txt">
									{__("pechat_text_holst")}
								</div>
							</li>
						</ul>
					</li>

					<li class="choose-material-item sidebar__item">
						<div class="choose_sub_inner">
							<a href="" class="choose-material-link" data-type="3" data-material="Стекло">Картинка на стекле</a>
							<ul class="dropdown-material-list">
								<li>
									<div class="holder-checkbox">
										<h4>Тип стекла</h4>
										<div>
											<label for="glass-type1" class="custom-label"><input class="placeholder-type" name="product_data[{$obj_id}][glasstype]" id="glass-type1" data-type="Тип стекла" type="radio" value="Акрил" checked><i></i> Акрил</label>
										</div>
										<div>
											<label class="custom-label" for="glass-type2"><input class="placeholder-type"  name="product_data[{$obj_id}][glasstype]" id="glass-type2" data-type="Тип стекла" type="radio"  value="Силикатное"><i></i> Силикатное</label>
										</div>
									</div>
									<div class="holder-checkbox">
										<h4>Держатели</h4>
										<div>
											<label for="holder1" class="custom-label"><input class="placeholder-type" name="product_data[{$obj_id}][holder]" id="holder1" data-type="Держатели" type="radio" value="Без держателя" checked><i></i> Без держателя</label>
										</div>
										<div>
											<label class="custom-label" for="holder2"><input class="placeholder-type"  name="product_data[{$obj_id}][holder]" id="holder2" data-type="Держатели" type="radio"  value="Дистанционный"><i></i> Дистанционный</label>
										</div>
										<div>
											<label class="custom-label" for="holder3"><input class="placeholder-type"  name="product_data[{$obj_id}][holder]" id="holder3" data-type="Держатели" type="radio"  value="Вплотную"><i></i> Вплотную</label>
										</div>
									</div>
									<div class="material-txt">
										{__("pechat_text_steklo")}
									</div>
								</li>
							</ul>					
						</div>
					</li>

				</ul>
			</div>
		</div>
		{assign var="form_close" value="form_close_`$obj_id`"}
		{$smarty.capture.$form_close nofilter}
	</div>
</div><!--  /end make product -->

<!-- begin seo-text -->
<div class="catalog-wrap-content poster-text line-border clearfix">
	<div class="text_block">{__("poster_text_seo")}</div>
	{* <div class="text_block-overlay"></div><div class="show-more-content"><a class="readmore">Читать далее &raquo;</a></div> *}
</div>
<!-- /end seo-text -->




<script>
	window.jQuery || document.write('<script src="js/lib/jquery/jquery.min.js"><\/script>');
	var imgurl='{$image}';
</script>
<script>
	var v_pict_cost={$settings_price[0]['pict_cost']};
	var maket_cost={$settings_price[0]['maket']};
	var sm_plast={$settings_price[0]['sm_plast']};
	var sm_plexiglass={$settings_price[0]['sm_plexiglass']};
	var sm_canvas={$settings_price[0]['sm_canvas']};
	var sm_slglass={$settings_price[0]['sm_slglass']};
	var fastener_cost={$settings_price[0]['fastener_cost']};
	var holder_cost={$settings_price[0]['holder_cost']};
	var varnish_cost={$settings_price[0]['varnish_cost']};
	var stretcher_angle={$settings_price[0]['stretcher_angle']};
	var stretcher_cost={$settings_price[0]['stretcher_cost']};
	var profile_cost={$settings_price[0]['profile_cost']};
	var obr_akril_cost={$settings_price[0]['obr_akril']};
	var obr_silikat_cost={$settings_price[0]['obr_silikat']};
	var ex_splits='{$product['splits']}';
</script>

<div class="hidden" title="undefined" id="null"><!--null--></div>

{else}
{capture name="val_hide_form"}{/capture}
{capture name="val_capture_options_vs_qty"}{/capture}
{capture name="val_capture_buttons"}{/capture}
{capture name="val_no_ajax"}{/capture}

{* NOTE: One of the selected product templates will be connected, depending on the 'Product details view' setting.
You can find product templates in the following directory: responsive/templates/blocks/product_templates/
Below are the display parameters we send to the product template.
*}

{include
	file=$product.product_id|fn_get_product_details_view
	product=$product
	show_sku=true
	show_rating=true
	show_old_price=true
	show_price=true
	show_list_discount=true
	show_clean_price=true
	details_page=true
	show_discount_label=true
	show_product_amount=true
	show_product_options=true
	hide_form=$smarty.capture.val_hide_form
	min_qty=true
	show_edp=true
	show_add_to_cart=true
	show_list_buttons=true
	but_role="action"
	capture_buttons=$smarty.capture.val_capture_buttons
	capture_options_vs_qty=$smarty.capture.val_capture_options_vs_qty
	separate_buttons=$smarty.capture.val_separate_buttons
	show_add_to_cart=true
	show_list_buttons=true
	but_role="action"
	block_width=true
	no_ajax=$smarty.capture.val_no_ajax
	show_product_tabs=true
}
{/if}