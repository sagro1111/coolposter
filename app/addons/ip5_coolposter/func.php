<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

use Tygh\Storage;
use Tygh\Registry;
use Tygh\Exceptions\DeveloperException;

function fn_ip5_coolposter_settings_variants_image_verification_use_for(&$objects)
{
	$objects['coolposter'] = __('use_for_coolposter');
}

function fn_ip5_coolposter_pre_add_to_cart($product_data, &$cart, $auth, $update)
{
	//fn_print_die($ids);
	//foreach ($product_data as $key => $data) {
	foreach ($product_data as $id => $value) {
		//$id = (!empty($data['product_id'])) ? intval($data['product_id']) : intval($key);
		//fn_print_die($product_data );
		if ($product_data[$id]['splits_img']) {
			if (!empty($_REQUEST['cart_products'])) {
				foreach ($_REQUEST['cart_products'] as $_key => $_data) {
					if (empty($_data['amount']) && !isset($cart['products'][$_key]['extra']['parent'])) {
						fn_delete_cart_product($cart, $_key);
					}
				}
				fn_add_product_to_cart($_REQUEST['cart_products'], $cart, $auth, true);
				fn_save_cart_content($cart, $auth['user_id']);
			}
			$data = explode(',', $product_data[$id]['splits_img']);
			$data = str_replace(' ', '+', $data[1]);
			$img_id = db_get_field('SELECT detailed_id FROM ?:images_links WHERE object_id=?i', $id);//$cart['products'][$id]['product_id']);
			$fname = "var/custom_files/" . $id . ".jpg";
			file_put_contents($fname, base64_decode($data));
			if ($img_id) {
				fn_cool_update_product_image($id, 'M', $id . ".jpg", $fname);
			}

		}
	}

}


function fn_ip5_coolposter_post_add_to_cart($product_data, &$cart, $auth, $update, $ids)
{
	foreach ($ids as $id => $value) {
		$splits = $product_data[$value]['splits'];
		if ($splits) {
			$cart['products'][$id]['extra']['splits'] = print_r(json_decode($splits, true), true);;
		}
		if ($product_data[$value]['material']) {
			$cart['products'][$id]['extra']['material'] = $product_data[$value]['material'];
		}
		if ($product_data[$value]['glass-type']) {
			$cart['products'][$id]['extra']['glasstype'] = $product_data[$value]['glass-type'];
		}
		if ($product_data[$value]['splits_info']) {
			$cart['products'][$id]['extra']['splits_info'] = $product_data[$value]['splits_info'];
		}
		if ($product_data[$value]['imgHref']) {
			$cart['products'][$id]['extra']['imgHref'] = $product_data[$value]['splits_info'];
		}
		if ($product_data[$value]['size']) {
			$cart['products'][$id]['extra']['size'] = $product_data[$value]['size'];
		}
		if ($product_data[$value]['form']) {
			$cart['products'][$id]['extra']['form'] = $product_data[$value]['form'];
		}
		if ($product_data[$value]['shutter']) {
			$cart['products'][$id]['extra']['shutter'] = $product_data[$value]['shutter'];
		}
		if ($product_data[$value]['holder']) {
			$cart['products'][$id]['extra']['holder'] = $product_data[$value]['holder'];
		}
		if ($product_data[$value]['price']) {
			$cart['products'][$id]['price'] = $product_data[$value]['price'];
			$cart['products'][$id]['stored_price'] = 'Y';
		}



		if (Storage::instance('custom_files')->isExist('original/'.$cart['products'][$id]['product_id'].".jpg")) {
			fn_print_r("EXIST");
			$cart['products'][$id]['extra']['original'] = '/var/custom_files/original/'.$cart['products'][$id]['product_id'].".jpg";
		}

		if($product_data[$value]['splits']){
			$splits = $product_data[$value]['splits'];
			$params['splits']=$splits;
			fn_update_product($params,$cart['products'][$id]['product_id']);
		}

	}
}
function fn_ip5_coolposter_get_order_info(&$order, $additional_data) {
	//fn_print_r($order);
}

function fn_cool_get_unsorted() {
	$id = db_get_field(
		"	SELECT ?:categories.category_id
		FROM ?:categories
		LEFT JOIN ?:category_descriptions
		ON ?:categories.category_id = ?:category_descriptions.category_id
		WHERE ?:category_descriptions.category = ?s",
		'Фото загруженные пользователями'
	);

	//fn_print_die($id);

	return $id;
}

function fn_cool_inner_call($url, $params = false) {
	$client_id = Registry::get('addons.ip5_coolposter.client_id');
	$client_secret = Registry::get('addons.ip5_coolposter.client_secret');

	if ($client_id && $client_secret) {
		$root = "https://api.shutterstock.com/v2";

		$ch = curl_init();
		curl_setopt($ch, CURLOPT_USERPWD, implode(':', array($client_id, $client_secret)));
		curl_setopt($ch, CURLOPT_USERAGENT, 'Shutterstock-PHP/2.0.4');
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
		curl_setopt($ch, CURLOPT_TIMEOUT, 600);
		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));

		if ($params) {

			$query = http_build_query($params);
			$url .= "?$query";
			$url.='&view=full';

		}

		curl_setopt($ch, CURLOPT_URL, $root . $url);

        //$params = print_r($params, true);
        //fn_cschimp_print_debug("Call to ${root}${url} with params: $params");
		$response = curl_exec($ch);

        /*if ($response)
        fn_cschimp_print_debug($response);*/

        return $response;
    } else {
    	fn_set_notification('W', __('warning'), __('no_keys'));
    }

    return false;
}

function fn_cool_get_image($id) {
	$response = fn_cool_inner_call("/images/${id}");

	if ($response) {
		$response = json_decode($response, true);

		//fn_print_die($response);
		if (!empty($response['assets'])) {
			return $response;
		}
	}

	return false;
}

function fn_cool_get_pictures($params, $items_per_page) {
	$products = array();

	if (empty($params['sort_by'])) {
		$params = array_merge($params, fn_get_default_products_sorting());
	}
	if(empty($params['type']))
	{
		$params['type']=array('photo', 'illustration');
	}
	if (empty($params['orientation'])) {
		$params['orientation'] = 'horizontal';
	}
	if (empty($params['page'])) {
		$params['page'] = 1;
	}

	if (empty($params['items_per_page'])) {
		$params['items_per_page'] = $items_per_page;
	}

	$coolparams = array(
		'image_type' => $params['type'],
		'per_page' => $params['items_per_page'],
		'page' => $params['page'],
		'orientation' => $params['orientation']
	);

	if (isset($params['category'])) {
		$category = $params['category'];
		$data = fn_get_category_data($category);

		//fn_print_die($data);
		$parent_id = $data['parent_id'];
		$category = $data['coolcategory'];
		//fn_print_die($data);
		$display = $data['category'];
        //$type = $data['cooltype'];

		if (!$category && $parent_id) {
			$parent_data = fn_get_category_data($parent_id);
			$category = $parent_data['coolcategory'];
			$display = $parent_data['category'];
		}

		//fn_print_die($category);
		$coolparams['category'] = $category;
		$coolparams['query'] = $data['coolquery'];

		$params['display'] = $display;
	} elseif (isset($_REQUEST['search'])) {
		$search = $params['search'];
		$coolparams['query'] = $search;

		$params['display'] = $params['search'];
	}

	$response = fn_cool_inner_call("/images/search", $coolparams);

	if ($response) {
		$response = json_decode($response, true);

		if (!empty($response['data'])) {
			$products = $response['data'];
			$params['total_items'] = $response['total_count'];
		}
	}
	return array($products, $params);
}

function fn_cool_generate_data($data) {
	$products = array();

	foreach($data as $item) {
		$id = $item['id'];
		$products[$id] = array(
			'product_id' => $id,
			'amount' => 1,
			'assets' => $item['assets']
		);
	}

	return $products;
}

function fn_cool_update_category($data, $id) {
	if ($id) {
		db_query("UPDATE ?:cool_categories SET ?u WHERE category_id = ?i", $data, $id);
	} else {
		$id = db_query("INSERT INTO ?:cool_categories ?e", $data);
	}

	return $id;
}

function fn_cool_get_category_data($id) {
	return db_get_row("SELECT * FROM ?:cool_categories WHERE category_id = ?i", $id);
}

function fn_cool_get_categories() {
	return db_get_array("SELECT * FROM ?:cool_categories");
}

function fn_cool_delete_category($category_ids) {
	foreach((array)$category_ids as $id) {
		db_query("DELETE FROM ?:cool_categories WHERE category_id = ?i", $id);
		db_query("DELETE FROM ?:cool_splits WHERE category_id = ?i", $id);
	}
}

function fn_cool_delete_split($split_id) {
	db_query("DELETE FROM ?:cool_splits WHERE split_id = ?i", $split_id);
}

function fn_cool_update_split($data, $split_id) {
	if ($split_id) {
		db_query("UPDATE ?:cool_splits SET ?u WHERE split_id = ?i", $data, $split_id);
	} else {
		$split_id = db_query("INSERT INTO ?:cool_splits ?e", $data);
	}

	return $split_id;
}

function fn_cool_update_settings($data, $split_id) {
	if ($split_id) {
		db_query("UPDATE ?:cool_settings SET ?u WHERE setting_id = ?i", $data, $split_id);
	} else {
		$split_id = db_query("INSERT INTO ?:cool_settings ?e", $data);
	}

	return $split_id;
}
function fn_cool_get_settings($settings_id) {
	return db_get_row(
		"SELECT * FROM ?:cool_settings WHERE setting_id = ?i",
		$settings_id);
}

function fn_cool_get_split($split_id) {
	return db_get_row(
		"SELECT * FROM ?:cool_splits WHERE split_id = ?i",
		$split_id);
}

function fn_cool_get_splits($category_id) {
	return db_get_array(
		"SELECT * FROM ?:cool_splits WHERE category_id = ?i",
		$category_id);
}

function fn_cool_insert_image() {
	//fn_print_die('here');
	$uploaded_data = fn_filter_uploaded_data('cool_data');
	//fn_print_die($uploaded_data);

	if (!empty($uploaded_data)) {
		$files_data = array();

		foreach ($uploaded_data as $key => $file) {
			;
			if ($file['size'] > COOL_MAX_FILE_SIZE) {
				fn_set_notification('E', __('error'), $file['name'] . ': ' . __('text_forbidden_uploaded_file_size', array(
					'[size]' => COOL_MAX_FILE_SIZE . ' kb'
				)));

				return 0;
			}

			$extension = fn_get_image_extension($file['type']);

			if (empty($extension)) {
				fn_set_notification('E', __('error'), $file['name'] . ': ' . __('cool_forbidden_uploaded_file_type', array(
					'[type]' => $file['type']
				)));

				return 0;
			}

			list(, $_file_path) = Storage::instance('custom_files')->put('coolposter', array(
				'file' => $file['path']
			));

			$filename = trim($_file_path, '.') . '.' . $extension;

			Storage::instance('custom_files')->copy($_file_path, $filename);
			Storage::instance('custom_files')->delete($_file_path);

			$resized = fn_cool_make_resized($filename);

			$data = array(
				'file_name' => $filename,
				'resized' => $resized
			);

			return db_query("INSERT INTO ?:cool_uploads ?e", $data);
		}
	}
}

function fn_cool_get_uploaded($id) {
	$file = db_get_field("SELECT file_name from ?:cool_uploads WHERE image_id = ?i", $id);

	if ($file) {
		return $file;
	} else {
		throw new DeveloperException("Unknown uploaded file ID: ${id}");
	}
}

function fn_cool_get_resized($id) {
	$file = db_get_field("SELECT resized from ?:cool_uploads WHERE image_id = ?i", $id);

	if ($file) {
		return Storage::instance('custom_files')->getUrl($file);
	} else {
		throw new DeveloperException("No resized image for ID: ${id}");
	}
}

function fn_cool_make_resized($file) {

	//fn_print_die($file);
	list(, , ,$tmp_path) = fn_get_image_size(Storage::instance('custom_files')->getAbsolutePath($file));

	//fn_print_die($tmp_path);
	list($cont, $format) = fn_resize_image($tmp_path, COOL_WIDTH);
	//fn_print_die( Storage::instance('custom_files')->getAbsolutePath($file));
	$filename = "/resized/${file}";

	if (!empty($cont)) {
		list(, $img) = Storage::instance('custom_files')->put($filename, array(
			'contents' => $cont,
			'caching' => true
		));
	}

	return $img;
}
function fn_cool_make_resized_upd($file) {
	//fn_print_die($file);
	list(, , ,$tmp_path) = fn_get_image_size(Storage::instance('custom_files')->getAbsolutePath($file));
	//fn_print_die($tmp_path);
	list($cont, $format) = fn_resize_image($tmp_path, COOL_WIDTH);
	//fn_print_die( Storage::instance('custom_files')->getAbsolutePath($file));
	$filename = "/resized${file}";
	if (!empty($cont)) {
		list(, $img) = Storage::instance('custom_files')->put($filename, array(
			'contents' => $cont,
			'caching' => true
		));
	}

	return $img;
}
function fn_ip5_coolposter_get_products(&$params, &$fields, &$sortings, &$condition, &$join, &$sorting, &$group_by, &$lang_code, &$having)
{

/*	//fn_print_r($sortings);
	if(($params['sort_by']=="popularity")&&($params['dispatch'] == "hits.view"))
	{
		$sortings['popularity_from']='0';
		$sortings['popularity_to']='1';
		$join .= ' INNER JOIN ?:product_sales ON ?:product_sales.product_id = products.product_id AND ?:product_sales.category_id = products_categories.category_id ';

		$sortings['popularity'] = '?:product_sales.amount';
		return true;
	}
	if(($params['sort_by']=="popularity")&&($params['dispatch'] == "popular.view"))
	{

		$sortings['popularity_from']='0';
		$sortings['popularity_to']='1';
		$join .= ' INNER JOIN ?:product_popularity ON ?:product_popularity.product_id = products.product_id';

		$sortings['popularity'] = '?:product_popularity.added';
		return true;
	}
*/

	return true;
}
function fn_ip5_coolposter_get_products_pre(&$params, &$items_per_page, &$lang_code)
{
	//fn_print_r($params);
	if (!empty($params['bestsellers'])) {
		$params['extend'][] = 'categories';
	} elseif (empty($params['sort_by']) || empty($sortings[$params['sort_by']])) {
		$default_sorting_params = fn_get_default_products_sorting();
		if ((!empty($params['sort_by']) && $params['sort_by'] == 'bestsellers') || ($default_sorting_params['sort_by'] == 'bestsellers') || isset($params['sales_amount_from']) || isset($params['sales_amount_to'])) {
			$params['extend'][] = 'categories';
			$params['extend'][] = 'sales';

		} elseif ((!empty($params['sort_by']) && $params['sort_by'] == 'on_sale') || $default_sorting_params['sort_by'] == 'on_sale') {
			$params['extend'][] = 'on_sale';
		}
	}

	if (!empty($params['similar'])) {

		$product = Tygh::$app['view']->getTemplateVars('product');

		if (!empty($params['main_product_id'])) {
			$params['exclude_pid'] = $params['main_product_id'];
		}

		if (!empty($params['similar_category']) && $params['similar_category'] == 'Y') {
			$params['cid'] = $product['main_category'];

			if (!empty($params['similar_subcats']) && $params['similar_subcats'] == 'Y') {
				$params['subcats'] = 'Y';
			}
		}

		if (!empty($product['price'])) {

			if (!empty($params['percent_range'])) {
				$range = $product['price'] / 100 * $params['percent_range'];

				$params['price_from'] = $product['price'] - $range;
				$params['price_to'] = $product['price'] + $range;
			}

		}
	}
}
function updateProductImage($filename, $product_id, $type, $lang_code)
{
	$url_images = Storage::instance('custom_files');

	if (file_exists($url_images . $filename)) {
		$detail_file = fn_explode('.', $filename);
		$type_file = array_shift($detail_file);
		$condition = db_quote(" AND images.image_path LIKE ?s", "%" . $type_file . "%");
		$images = db_get_array(
			"SELECT images.image_id, images_links.pair_id"
			. " FROM ?:images AS images"
			. " LEFT JOIN ?:images_links AS images_links ON images.image_id = images_links.detailed_id"
			. " WHERE images_links.object_id = ?i $condition", $product_id);

		if (!empty($images) && !empty($type)) {
			foreach ($images as $k_image => $image) {
				db_query("UPDATE ?:images_links SET type = ?s WHERE pair_id = ?i", $type, $image['pair_id']);
				$images[$k_image]['type'] = $type;
			}
		}

		$image_data[] = array(
			'name' => $filename,
			'path' => $url_images . $filename,
			'size' => filesize($url_images . $filename),
		);

		if (!empty($images)) {
			$pair_data = $images;
		} else {
			$pair_data[] = array(
				'pair_id' => '',
				'type' => $type,
				'object_id' => 0
			);
		}

		$pair_ids = fn_update_image_pairs(array(), $image_data, $pair_data, $product_id, 'product', array(), 1, $lang_code);
	}
}

function fn_cool_insert_image_to_product($product_id, $type) {
	$uploaded_data = fn_filter_uploaded_data('cool_data');
	if (!empty($uploaded_data)) {
		$files_data = array();

		foreach ($uploaded_data as $key => $file) {
			//fn_print_r($key);
			//fn_print_die($file);
			if ($file['size'] > COOL_MAX_FILE_SIZE) {
				fn_set_notification('E', __('error'), $file['name'] . ': ' . __('text_forbidden_uploaded_file_size', array(
					'[size]' => COOL_MAX_FILE_SIZE . ' kb'
				)));

				return 0;
			}

			$extension = fn_get_image_extension($file['type']);

			if (empty($extension)) {

				fn_set_notification('E', __('error'), $file['name'] . ': ' . __('cool_forbidden_uploaded_file_type', array(
					'[type]' => $file['type']
				)));

				return 0;
			}

			list(, $_file_path) = Storage::instance('custom_files')->put('coolposter', array(
				'file' => $file['path']
			));


			$filename = trim($_file_path, '.') . '.' . $extension;


			Storage::instance('custom_files')->copy($_file_path, "original/".$product_id.'.jpg');
			Storage::instance('custom_files')->copy($_file_path, $filename);
			// Storage::instance('custom_files')->delete($_file_path);

			$filename= str_replace('/', "", $filename);
			$resized = fn_cool_make_resized($filename);
			$basefilename=basename($resized,'.' . $extension);
			//fn_print_die($basefilename);

			//$filename=$basefilename;
			$data = array(
				'file_name' => $basefilename,
				'resized' => $resized
			);
			//return db_query("INSERT INTO ?:cool_uploads ?e", $data);


			$img_id=db_query("INSERT INTO ?:cool_uploads ?e", $data);

			$pos = mb_strpos($filename, "coolposter");
			$filename=substr($filename, $pos);
			//fn_print_r(Storage::instance('custom_files')->options['dir'].'custom_files/'.$filename);

			if (file_exists(Storage::instance('custom_files')->options['dir'].'custom_files/'.$filename)) {
				//fn_print_r("img_id".$img_id);
				//$detail_file = fn_explode('.', $filename);
				$type_file = $extension;
				$condition = db_quote(" AND images.image_path LIKE ?s", "%" . $type_file . "%");
				$images = db_get_array(
					"SELECT images.image_id, images_links.pair_id"
					. " FROM ?:images AS images"
					. " LEFT JOIN ?:images_links AS images_links ON images.image_id = images_links.detailed_id"
					. " WHERE images_links.object_id = ?i $condition", $product_id);

				if (!empty($images) && !empty($type)) {
					foreach ($images as $k_image => $image) {
						db_query("UPDATE ?:images_links SET type = ?s WHERE pair_id = ?i", $type, $image['pair_id']);
						$images[$k_image]['type'] = $type;
					}
				}

				$image_data[] = array(
					//'name' =>  $file['name'] ,
					'name' => $basefilename,
					'path' =>  Storage::instance('custom_files')->options['dir'].'custom_files/'.$filename,
					'size' => filesize(Storage::instance('custom_files')->options['dir'].'custom_files/'.$filename),
				);
				if (!empty($images)) {
					$pair_data = $images;
				} else {
					$pair_data[] = array(
						'pair_id' => '',
						'type' => $type,
						'object_id' => 0
					);
				}

				$pair_ids = fn_update_image_pairs(array(), $image_data, $pair_data, $product_id, 'product', array(), 1);

				return $img_id;
			}
		}
	}
	return null;
}
function fn_cool_update_product_image($product_id, $type,$pngFileName,$pngFilePath) {
	//$uploaded_data = fn_filter_uploaded_data('cool_data');
	$files_data = array();
	$extension = "jpg";
	list(, $_file_path) = Storage::instance('custom_files')->put('coolposter', array(
		'file' => Storage::instance('custom_files')->options['dir'].'custom_files/'.$pngFileName
	));


	$filename = trim($_file_path, '.') . '.' . $extension;

	//$_file_path=$_file_path.$extension;


	Storage::instance('custom_files')->copy($_file_path, $filename);
	Storage::instance('custom_files')->delete($_file_path);



	$resized = fn_cool_make_resized_upd($filename);

	$data = array(
		'file_name' => $filename,
		'resized' => $resized
	);
	//return db_query("INSERT INTO ?:cool_uploads ?e", $data);


	$img_id=db_query("INSERT INTO ?:cool_uploads ?e", $data);

	$pos = mb_strpos($filename, "coolposter");
	$filename=substr($filename, $pos);
	//fn_print_r(Storage::instance('custom_files')->options['dir'].'custom_files/'.$filename);

	if (file_exists(Storage::instance('custom_files')->options['dir'].'custom_files/'.$filename)) {
		//fn_print_r("img_id".$img_id);
		//$detail_file = fn_explode('.', $filename);
		$type_file = $extension;
		$condition = db_quote(" AND images.image_path LIKE ?s", "%" . $type_file . "%");
		$images = db_get_array(
			"SELECT images.image_id, images_links.pair_id"
			. " FROM ?:images AS images"
			. " LEFT JOIN ?:images_links AS images_links ON images.image_id = images_links.detailed_id"
			. " WHERE images_links.object_id = ?i $condition", $product_id);

		if (!empty($images) && !empty($type)) {
			foreach ($images as $k_image => $image) {
				db_query("UPDATE ?:images_links SET type = ?s WHERE pair_id = ?i", $type, $image['pair_id']);
				$images[$k_image]['type'] = $type;
			}
		}

		$image_data[] = array(
			'name' => $pngFileName,
			'path' =>  Storage::instance('custom_files')->options['dir'].'custom_files/'.$filename,
			'size' => filesize(Storage::instance('custom_files')->options['dir'].'custom_files/'.$filename),
		);
		if (!empty($images)) {
			$pair_data = $images;
		} else {
			$pair_data[] = array(
				'pair_id' => '',
				'type' => $type,
				'object_id' => 0
			);
		}

		$pair_ids = fn_update_image_pairs(array(), $image_data, $pair_data, $product_id, 'product', array(), 1);
		//fn_print_die($pair_ids);
		return $img_id;
	}


	return null;
}

function fn_cool_make_resizedEx($file) {
	//fn_print_die($file);
	list(, , ,$tmp_path) = fn_get_image_size(Storage::instance('custom_files')->getAbsolutePath($file));
	//fn_print_die($tmp_path);
	list($cont, $format) = fn_resize_image($tmp_path, COOL_WIDTH);
	//fn_print_die( Storage::instance('custom_files')->getAbsolutePath($file));
	$filename = "resized/${file}";

	if (!empty($cont)) {
		list(, $img) = Storage::instance('custom_files')->put($filename, array(
			'contents' => $cont,
			'caching' => true
		));
	}

	return $img;
}
function fn_shutterstock_insert_image_to_product($product_id, $type, $cool_id) {
	//fn_print_die('555');
	$length = 4;
	$chartypes = "lower,numbers";
	$extension = 'jpg';
	$name = $cool_id;//random_string($length, $chartypes);
	$imageName=$name. '.' . $extension;

	//$tmpImagePath='D:/OpenServer/domains/coolposter.loc/var/cache/misc/1/tmp/tmp'.$name.'.tmp';
	$tmpPath=Storage::instance('custom_files')->options['dir'].'cache/misc/1/tmp';
	$tmpImagePath=$tmpPath.'/tmp'.$name.'.jpg';

	mkdir($tmpPath, 0777, true);
	//fn_print_die(dirname($tmpPath));
	//$tmpImagePath='D:/OpenServer/domains/coolposter.loc/var/cache/misc/1/tmp/tmp'.$name.'.tmp';
	//list(, $tmpImagePath) = Storage::instance('custom_files')->put('coolposter', array(
	//	'file' => 'D:/OpenServer/domains/coolposter.loc/var/cache/misc/1/tmp/tmp'.$name.'.tmp'
	//));


	$uploadedImagePath=Storage::instance('custom_files')->options['dir'].'custom_files/'.$imageName;


	$resp=fn_cool_get_image($cool_id);

	$url_pic = $resp['assets']['preview']['url'];
	$re = "/(?!.*\\/)(.*)/";

	preg_match($re, $url_pic, $match);
	try {
		$ch = curl_init();
		$fp = fopen( $tmpImagePath, 'w+b');

		curl_setopt($ch, CURLOPT_URL,'http://image.shutterstock.com/z/'.$match[1]);

		curl_setopt($ch, CURLOPT_TIMEOUT, 50);
		curl_setopt($ch, CURLOPT_FILE, $fp);
		curl_setopt($ch, CURLOPT_HEADER, 0);
		curl_exec($ch);



		curl_close($ch);
		fclose($fp);
	} catch (Exception $e) {
		fn_print_die( $e->getMessage());
	}
	//fn_print_r($cool_id);

	//fn_print_die('55');

/*
	$uploaded_data['image']['name']=$name.'.jpg';
	$uploaded_data['image']['type']='image/jpeg';
	$uploaded_data['image']['path']='D:/OpenServer/domains/coolposter.loc/var/cache/misc/1/tmp/tmp'.$name.'.tmp';
	$uploaded_data['image']['size']=filesize ('D:/OpenServer/domains/coolposter.loc/var/cache/misc/1/tmp/tmp'.$name.'.tmp');
	$uploaded_data['image']['error']='0';
	$uploaded_data = fn_filter_uploaded_data('cool_data');
*/




	if (!file_exists($tmpImagePath)) return null;
	//fn_print_die('55');

	//fn_print_die($uploadedImagePath);
	//$filenameTmp = trim($tmpImagePath, '.') . '.' . $extension;
	rename($tmpImagePath, $uploadedImagePath);
	//fn_print_die('55');
	//delete ( $tmpImagePath);


	//		Storage::instance('custom_files')->copy($tmpImagePath,$imageName);
	//		Storage::instance('custom_files')->delete($tmpImagePath);
	//fn_print_die($uploadedImagePath);
	//fn_print_die($imageName);
	if (!file_exists($uploadedImagePath)) return null;


	//fn_print_r('5');
	//$filenameTmp = trim($tmpImagePath, '.') . '.' . $extension;
	$resized = fn_cool_make_resized($imageName);

	$data = array(
		'file_name' => $name,
		'resized' => $resized
	);
			//return db_query("INSERT INTO ?:cool_uploads ?e", $data);
	//fn_print_die($data);

	$img_id=db_query("INSERT INTO ?:cool_uploads ?e", $data);


	//fn_print_die($data);

	if (file_exists($uploadedImagePath)) {
				//fn_print_r("img_id".$img_id);

				//$detail_file = fn_explode('.', $filename);
		$type_file = $extension;
		$condition = db_quote(" AND images.image_path LIKE ?s", "%" . $type_file . "%");
		$images = db_get_array(
			"SELECT images.image_id, images_links.pair_id"
			. " FROM ?:images AS images"
			. " LEFT JOIN ?:images_links AS images_links ON images.image_id = images_links.detailed_id"
			. " WHERE images_links.object_id = ?i $condition", $product_id);

		if (!empty($images) && !empty($type)) {
			foreach ($images as $k_image => $image) {
				db_query("UPDATE ?:images_links SET type = ?s WHERE pair_id = ?i", $type, $image['pair_id']);
				$images[$k_image]['type'] = $type;
			}
		}

		$image_data[] = array(
			'name' =>  $name ,
			'path' =>  $uploadedImagePath,
			'size' => filesize($uploadedImagePath),
		);
		if (!empty($images)) {
			$pair_data = $images;
		} else {
			$pair_data[] = array(
				'pair_id' => '',
				'type' => $type,
				'object_id' => 0
			);
		}

		$pair_ids = fn_update_image_pairs(array(), $image_data, $pair_data, $product_id, 'product', array(), 1);

		return $img_id;
	}
	return null;
}
function fn_ip5_coolposter_add_to_cart(&$cart, &$product_id, &$_id)
{

}
