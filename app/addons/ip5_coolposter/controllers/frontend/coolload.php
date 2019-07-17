<?php

fn_define('KEEP_UPLOADED_FILES', true);

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	//fn_print_die($_REQUEST);
	if ($mode == 'upload' && isset($_REQUEST['file_cool_data'])) {

		//fn_trusted_vars('file_image');	
		
		if (fn_image_verification('coolposter', $_REQUEST) == false) {
			//fn_save_post_data('form_values');
			return array(CONTROLLER_STATUS_REDIRECT, 'coolload.view');
		}
		
		//fn_print_die();
		//$cool_id = fn_cool_insert_image();


		$params['product'] = fn_truncate_chars(addslashes($_REQUEST['name']), 250);
		$params['company_id'] = 1;
		$params['amount'] = 1;
		$params['category_ids'][] = fn_cool_get_unsorted("Фото загруженные пользователями");
		$params['coolimage'] = "";
		$params['return_period'] = "900";
		$params['zero_price_action'] = 'P';
		$params['product_code'] = uniqid();
		$params['price'] = 0; //Что-то вроде, дебаг *price*


		$id = fn_update_product($params,0);


		$cool_id =fn_cool_insert_image_to_product($id,'M');


//fn_print_r("id ".$id);
		
		if (!$cool_id) {
			return array(CONTROLLER_STATUS_OK, 'coolload.view');
		} else {

			return array(CONTROLLER_STATUS_REDIRECT, "products.view?image_id=".$cool_id."&product_id=$id");
		}
	}
}else {
	fn_add_breadcrumb("Загрузка изображений");
	$product_data = fn_restore_post_data('product_data');
	Tygh::$app['view']->assign('product_data', $product_data);
}