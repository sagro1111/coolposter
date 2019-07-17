<?php

use Tygh\Enum\ProductTracking;
use Tygh\Enum\ProductFeatures;
use Tygh\Registry;
use Tygh\Storage;
use Tygh\BlockManager\Block;
use Tygh\BlockManager\ProductTabs;
use Tygh\Navigation\LastView;
use Tygh\Languages\Languages;
use Tygh\Tools\Math;
use Tygh\Tools\SecurityHelper;
if (!defined('BOOTSTRAP')) { die('Access denied'); }

//return array(CONTROLLER_STATUS_REDIRECT, 'products.view?product_id=' . $_REQUEST['product_id']);

if ($mode == "view") {
    $params = $_REQUEST;
    $params['sort_by']='popularity';
    $params['extend'] = array('description');


} else {

    $title = __('products');
}


fn_add_breadcrumb('Популярные фото');

list($products, $search) = fn_get_products($params, Registry::get('settings.Appearance.products_per_page'));
//list($products, $search) = fn_get_added_products($params, Registry::get('settings.Appearance.products_per_page'));

fn_gather_additional_products_data($products, array('get_icon' => true, 'get_detailed' => true, 'get_additional' => true, 'get_options' => true));

$params['ip5_coolposter'] = true;
$selected_layout = fn_get_products_layout($params);
//$selected_layout = fn_get_products_layout($params);
//fn_print_r($products);
foreach($products as $product )
{
   // fn_print_r($product['product_id']);
    if($products[$product['product_id']]) {
      //  fn_print_r($product['product_id']);
        if ($products[$product['product_id']]['coolimage'] != '0') {
            $products[$product['product_id']]['preview_url'] = "http://image.shutterstock.com/z/-" . $products[$product['product_id']]['coolimage'] . ".jpg";
            $products[$product['product_id']]['main_pair']["detailed"]["image_path"] = $products[$product['product_id']]['preview_url'];
        }
    }
}

Tygh::$app['view']->assign('products', $products);
Tygh::$app['view']->assign('search', $search);
Tygh::$app['view']->assign('title', 'Популярные фото');
Tygh::$app['view']->assign('selected_layout', $selected_layout);


