<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	//fn_print_die($_REQUEST);

	if ($mode == 'update') {
		//fn_print_die($_REQUEST);
		$category_id = fn_cool_update_category($_REQUEST['category_data'], $_REQUEST['category_id']);

		if ($category_id) {
			return array(CONTROLLER_STATUS_OK, "coolposter.update?category_id=" . $category_id);
		} else {
			return array(CONTROLLER_STATUS_OK, "coolposter.add");
		}
	} elseif ($mode == 'm_update') {
		$categories = $_REQUEST['category_data'];

		if (!empty($categories)) {
			foreach($categories as $category_id => $category_data) {

			}
		}

		return array(CONTROLLER_STATUS_OK, "coolposter.manage");
	} elseif ($mode == 'delete') {
		fn_cool_delete_category($_REQUEST['category_id']);
		return array(CONTROLLER_STATUS_OK, "coolposter.manage");
	} elseif ($mode == 'm_delete') {
		fn_cool_delete_category($_REQUEST['category_ids']);
		return array(CONTROLLER_STATUS_OK, "coolposter.manage");
	}
}

if ($mode == 'manage') {
	$categories = fn_cool_get_categories();
	Tygh::$app['view']->assign('categories', $categories);
} elseif ($mode == 'update') {
	if (!empty($_REQUEST['category_id'])) {
		$data = fn_cool_get_category_data($_REQUEST['category_id']);

		if ($data) {
			$splits = fn_cool_get_splits($_REQUEST['category_id']);

			Tygh::$app['view']->assign('category_data', $data);
			Tygh::$app['view']->assign('splits', $splits);
		} else {
			return array(CONTROLLER_STATUS_NO_PAGE);
		}
	} else {
		return array(CONTROLLER_STATUS_NO_PAGE);
	}

}

