<?php
if ($mode == 'view') {

	if (isset($_REQUEST['image_id'])) {
		$id = $_REQUEST['image_id'];
		$data=fn_get_image_pairs($_REQUEST['product_id'], 'product', 'M');
		$url = fn_cool_get_resized($id);
		Tygh::$app['view']->assign('image', $url);


		//$user_id = db_query('INSERT INTO ?:users ?e', $user_data);
	}
	elseif (!empty($_REQUEST['product_id'])) {
			$product = fn_get_product_data(
			$_REQUEST['product_id'],
			$auth,
			CART_LANGUAGE,
			'',
			true,
			true,
			true,
			true,
			fn_is_preview_action($auth, $_REQUEST),
			true,
			false,
			true
		);
		if(empty($product['price']))
		{
			$id=$product['product_id'];
			$user_id = db_query("INSERT INTO ?:product_prices (product_id, price, lower_limit) VALUES($id, 0, 1)");
		}
		$image = $_REQUEST['product_id'];
		$image = db_get_field("SELECT coolimage FROM ?:products WHERE product_id = ?i", $image);

			$data = fn_cool_get_image($image);


		$email = db_get_field("SELECT category_id FROM ?:products_categories WHERE product_id = ?i", $_REQUEST['product_id']);





		//$x=mb_strpos($streng, $re);
		//fn_print_r($image);
		$data['assets']['preview']['url']="/var/custom_files/resized/".$image.".jpg";
		//$data['assets']['preview']['url']="http://image.shutterstock.com/z/".basename($data['assets']['preview']['url']);
		$image = $data['assets']['preview']['url'];
		//fn_print_die($image, $data);
		Tygh::$app['view']->assign('image', $image);


	} else {

		return array(CONTROLLER_STATUS_NO_PAGE);
	}
	$settings = db_get_array("SELECT * FROM ?:cool_settings WHERE setting_id = 1");
	Tygh::$app['view']->assign('settings_price', $settings);

	//fn_print_die(555);
}

