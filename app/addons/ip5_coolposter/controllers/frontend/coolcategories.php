<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

//return array(CONTROLLER_STATUS_REDIRECT, 'products.view?product_id=' . $_REQUEST['product_id']);

if ($mode == "view") {
    //8d0f2e8c2bd861b39240:1d6afc17b6400f2bf73e0056c4f2cb5e7e4fc25b

    /*$response = fn_cool_inner_call("/images/categories");
    if ($response) {
        $response = json_decode($response, true);
    }*/
    //fn_print_die(667777);
    $params = $_REQUEST;

    fn_add_breadcrumb('Категории фото для ваших картин', $link = '', $nofollow = false);

    //Tygh::$app['view']->assign('subcategories', fn_get_subcategories($_REQUEST['category_id']));
   // list($products, $search) = fn_top_menu_form(0);//fn_cool_get_pictures($params, Registry::get('settings.Appearance.products_per_page'));

    $items = fn_get_categories_tree();//fn_get_categories();

    Tygh::$app['view']->assign('items', $items);

    //Tygh::$app['view']->assign('search', $search);

    //fn_print_die(var_dump($products));
}
