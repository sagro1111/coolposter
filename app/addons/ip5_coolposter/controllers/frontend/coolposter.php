<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

//return array(CONTROLLER_STATUS_REDIRECT, 'products.view?product_id=' . $_REQUEST['product_id']);

if ($mode == 'get') {

	$categories = fn_cool_get_categories();
	$data = array();

	foreach ($categories as $category) {
		$splits = fn_cool_get_splits($category['category_id']);
		$category_data = array();
		$category_data['name'] = $category['name'];
		$category_data['splits'] = array();

		foreach ($splits as $split) {
			$rectangles = json_decode($split['rectangles'], true);
			$split_data = array();
			$split_data['id'] = $split['split_id'];
			$split_data['rectangles'] = $rectangles;

			$category_data['splits'][] = $split_data;
		}

		$data[] = $category_data;
	}

	if (defined('AJAX_REQUEST')) {
		Registry::get('ajax')->assign('cool_splits', json_encode($data));
		exit();
	} else {
		fn_print_die(json_encode($data));
	}

} elseif ($mode == 'create') {

	if (!empty($_REQUEST['image'])) {

		$id = $_REQUEST['image'];
		$data = fn_cool_get_image($id);

		if (empty($_REQUEST['category'])) {
			$category = fn_cool_get_unsorted();
		} else {
			$category = $_REQUEST['category'];
		}

		$params['product'] = fn_truncate_chars($data['description'], 250);
		$params['company_id'] = 1;
		$params['amount'] = 1;
		$params['category_ids'][] = $category;
		$params['coolimage'] = $data['id'];
		$params['zero_price_action'] = 'P';
		$params['product_code'] = uniqid();
        // $params['price'] = $data['price']; Что-то вроде, дебаг *price*
       

		$id = fn_update_product($params);

		fn_shutterstock_insert_image_to_product($id, 'M', $data['id']);

		if (defined('AJAX_REQUEST')) {
			Registry::get('ajax')->assign('coolproduct', $id);
			exit();
		} else {
			fn_print_die($id);
		}
	} else {
		return array(CONTROLLER_STATUS_NO_PAGE);
	}
} elseif ($mode == 'price') {

	if (!empty($_REQUEST['stuff'])) {
		$stuff = $_REQUEST['stuff'];
		$price = 0;

		if ($stuff == 'glass') {
			$glass_stuff = $_REQUEST['glass_stuff'];
			$glass_holders = $_REQUEST['glass_holders'];

			$price = 100;

			if ($glass_stuff == 'organic') {
				$price += 20;
			} elseif ($glass_stuff == 'silicat') {
				$price +=40;
			}

			if ($glass_holders == 'distance') {
				$price += 10;
			} elseif ($glass_holders == 'closely') {
				$price += 30;
			}

		} elseif ($stuff == 'holst') {
			$price = 200;
		} elseif ($stuff == 'vinil') {
			$price = 300;
		}

		if (defined('AJAX_REQUEST')) {
			Registry::get('ajax')->assign('price', $price);
			Registry::get('ajax')->assign('debug', $_REQUEST);
			exit();
		} else {
			fn_print_die($price);
		}
	} else {
		return array(CONTROLLER_STATUS_NO_PAGE);
	}
} elseif ($mode == "view") {

	//8d0f2e8c2bd861b39240:1d6afc17b6400f2bf73e0056c4f2cb5e7e4fc25b

	/*$response = fn_cool_inner_call("/images/categories");
	if ($response) {
		$response = json_decode($response, true);
	}*/

	$params = $_REQUEST;


	fn_add_breadcrumb(__('search_results'));

	list($products, $search) = fn_cool_get_pictures($params, Registry::get('settings.Appearance.products_per_page'));

	for($i=0; $i< sizeof($products); $i++){
		$products[$i]['assets']['preview']['url']="http://image.shutterstock.com/z/".basename($products[$i]['assets']['preview']['url']);
	}

	Tygh::$app['view']->assign('products', $products);
	Tygh::$app['view']->assign('search', $search);

	//fn_print_die(var_dump($products));
}
if (!empty($_REQUEST['image_id'])) {
	$id = $_REQUEST['image_id'];
	$url = fn_cool_get_resized($id);
		Tygh::$app['view']->assign('image', $url);


	//$user_id = db_query('INSERT INTO ?:users ?e', $user_data);
}