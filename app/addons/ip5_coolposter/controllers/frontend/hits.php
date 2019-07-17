<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

//return array(CONTROLLER_STATUS_REDIRECT, 'products.view?product_id=' . $_REQUEST['product_id']);

if ($mode == "view") {
    $params = $_REQUEST;

    $params['extend'] = array('description');
    $params['sort_by']="popularity";
}
     else {

        $title = __('products');
    }

    fn_add_breadcrumb('Хиты');

    list($products, $search) = fn_get_products($params, Registry::get('settings.Appearance.products_per_page'));

    fn_gather_additional_products_data($products, array('get_icon' => true, 'get_detailed' => true, 'get_additional' => true, 'get_options' => true));

    $params['ip5_coolposter'] = true;
    $selected_layout = fn_get_products_layout($params);
    //$selected_layout = fn_get_products_layout($params);

    Tygh::$app['view']->assign('products', $products);
    Tygh::$app['view']->assign('search', $search);
    Tygh::$app['view']->assign('title', 'Хиты');
    Tygh::$app['view']->assign('selected_layout', $selected_layout);
