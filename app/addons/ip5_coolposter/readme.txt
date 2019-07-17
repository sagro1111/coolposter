
!!!!!!!!!!!!!!! README BEFORE UPDATING
\app\addons\ip5_coolposter\


1.
	Убрал кнопку обновление корзины
design\themes\responsive\templates\views\checkout\components\cart_content.tpl



2.
	Убрал указание количества товаров в корзине и колонку с ценой
design\themes\responsive\templates\addons\ip5_coolposter\hooks\checkout\items_list.override.tpl
design\themes\responsive\templates\views\checkout\components\cart_items.tpl


3.
	{* cm-combination  - убрал классы для возможности перехода в корзину *}
	{*  cm-popup-box ty-dropdown-box__content hidden  убрал классы для всплывающего окна  *}
design\themes\responsive\templates\blocks\cart_content.tpl


