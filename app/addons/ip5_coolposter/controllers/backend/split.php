<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	if ($mode == 'update') {

		if (!empty($_REQUEST['split_data']) &&
			!empty($_REQUEST['split_data']['category_id'])) {
			$category_id = $_REQUEST['split_data']['category_id'];


			//fn_print_r($_REQUEST['split_data']);
			$split_id = fn_cool_update_split(
				$_REQUEST['split_data'],
				$_REQUEST['split_id']
			);

			if ($split_id) {
				return array(
					CONTROLLER_STATUS_OK,
					"split.update?category_id=" .
						$category_id .
						"&split_id=" .
						$split_id
				);
			} else {
				return array(CONTROLLER_STATUS_OK, "split.add");
			}
		} else {
			return array(CONTROLLER_STATUS_NO_PAGE);
		}
	} elseif ($mode == 'delete') {
		if (!empty($_REQUEST['split_id'])) {
			$split_id = $_REQUEST['split_id'];
			$data = fn_cool_get_split($split_id);
			$category_id = $data['category_id'];
			fn_cool_delete_split($split_id);

			return array(
				CONTROLLER_STATUS_OK,
				"coolposter.update?category_id=" . $category_id
			);
		} else {
			return array(CONTROLLER_STATUS_NO_PAGE);
		}
	}
}

if ($mode == 'add') {
	if (!empty($_REQUEST['category_id'])) {
		$category_id = $_REQUEST['category_id'];
		Tygh::$app['view']->assign('category_id', $category_id);
	} else {
		return array(CONTROLLER_STATUS_NO_PAGE);
	}
} elseif ($mode == 'update') {

	if (!empty($_REQUEST['split_id'])) {
		$split_id = $_REQUEST['split_id'];
		$data = fn_cool_get_split($split_id);
		//fn_print_die($data);
		Tygh::$app['view']->assign('category_id', $data['category_id']);
		Tygh::$app['view']->assign('split_data', $data);
	} else {
		return array(CONTROLLER_STATUS_NO_PAGE);
	}
}
