<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	
	if ($mode == 'update') {
		//fn_print_die($_REQUEST);
		
		$category_id = fn_cool_update_query(
			$_REQUEST['category_data'], 
			$_REQUEST['query_id'], 
			$_REQUEST['parent_id']);

		if ($category_id) {
			return array(CONTROLLER_STATUS_OK, "coolqueries.update?query_id=" . $category_id);
		} else {
			return array(CONTROLLER_STATUS_OK, "coolqueries.add");
		}
	} elseif ($mode == 'm_update') {
		$categories = $_REQUEST['category_data'];

		if (!empty($categories)) {
			foreach($categories as $category_id => $category_data) {
				fn_cool_update_query($category_data, $category_id);
			}
		}

		return array(CONTROLLER_STATUS_OK, "coolqueries.manage");
	} elseif ($mode == 'delete') {
		fn_cool_delete_query($_REQUEST['query_id']);
		return cool_check_parrent(isset($_REQUEST['parent_id']) ? $_REQUEST['parent_id'] : 0);
	} elseif ($mode == 'm_delete') {
		fn_cool_delete_query($_REQUEST['category_ids']);
		return cool_check_parrent(isset($_REQUEST['parent_id']) ? $_REQUEST['parent_id'] : 0);
	}
}

if ($mode == 'add') {
	if (!empty($_REQUEST['query_id'])) {
		$data['parent_id'] = $_REQUEST['query_id'];
		Tygh::$app['view']->assign('category_data', $data);
	}
} elseif ($mode == 'manage') {
	$categories = fn_cool_get_queries(0);
	Tygh::$app['view']->assign('categories', $categories);
} elseif ($mode == 'update') {
	if (!empty($_REQUEST['query_id'])) {
		$data = fn_cool_get_query_data($_REQUEST['query_id']);
		//fn_print_die($data);

		if ($data) {
			$subqueries = fn_cool_get_queries($_REQUEST['query_id']);

			Tygh::$app['view']->assign('category_data', $data);
			Tygh::$app['view']->assign('queries', $subqueries);
		} else {
			return array(CONTROLLER_STATUS_NO_PAGE);
		}
	} else {
		return array(CONTROLLER_STATUS_NO_PAGE);
	}
}

function cool_check_parrent($parent_id) {
	if ($parent_id) {
		return array(CONTROLLER_STATUS_OK, "coolqueries.update?query_id=${parent_id}");
	} else {
		return array(CONTROLLER_STATUS_OK, "coolqueries.manage");
	}
}
