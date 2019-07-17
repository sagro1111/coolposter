<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

//return array(CONTROLLER_STATUS_REDIRECT, 'products.view?product_id=' . $_REQUEST['product_id']);



 if ($mode == "view") {
	 $_statuses = array('A', 'H');
	$_condition = fn_get_localizations_condition('localization', true);
	$preview = fn_is_preview_action($auth, $_REQUEST);

	if (!$preview) {
		$_condition .= ' AND (' . fn_find_array_in_set($auth['usergroup_ids'], 'usergroup_ids', true) . ')';
		$_condition .= db_quote(' AND status IN (?a)', $_statuses);
	}

	if (fn_allowed_for('ULTIMATE')) {
		$_condition .= fn_get_company_condition('?:categories.company_id');
	}

	$category_exists = db_get_field(
		"SELECT category_id FROM ?:categories WHERE category_id = ?i ?p",
		$_REQUEST['category'],
		$_condition
	);

	if (!empty($category_exists)) {

		// Save current url to session for 'Continue shopping' button
		Tygh::$app['session']['continue_url'] = "catalog.view?category=$_REQUEST[category]";

		// Save current category id to session
		Tygh::$app['session']['current_category'] = Tygh::$app['session']['breadcrumb_category'] = $_REQUEST['category'];

		// Get subcategories list for current category
		Tygh::$app['view']->assign('subcategories', fn_get_subcategories($_REQUEST['category']));

		// Get full data for current category
		$category_data = fn_get_category_data($_REQUEST['category'], CART_LANGUAGE, '*', true, false, $preview);

		$category_parent_ids = fn_explode('/', $category_data['id_path']);
		array_pop($category_parent_ids);

		if (!empty($category_data['meta_description']) || !empty($category_data['meta_keywords'])) {
			Tygh::$app['view']->assign('meta_description', $category_data['meta_description']);
			Tygh::$app['view']->assign('meta_keywords', $category_data['meta_keywords']);
		}

		$params = $_REQUEST;

		if ($items_per_page = fn_change_session_param(Tygh::$app['session'], $_REQUEST, 'items_per_page')) {
			$params['items_per_page'] = $items_per_page;
		}
		if ($sort_by = fn_change_session_param(Tygh::$app['session'], $_REQUEST, 'sort_by')) {
			$params['sort_by'] = $sort_by;
		}
		if ($sort_order = fn_change_session_param(Tygh::$app['session'], $_REQUEST, 'sort_order')) {
			$params['sort_order'] = $sort_order;
		}

		$params['cid'] = $_REQUEST['category'];
		$params['extend'] = array('categories', 'description');
		$params['subcats'] = '';
		if (Registry::get('settings.General.show_products_from_subcategories') == 'Y') {
			$params['subcats'] = 'Y';
		}

		$show_no_products_block = (!empty($params['features_hash']) && !$products);
		if ($show_no_products_block && defined('AJAX_REQUEST')) {
			fn_filters_not_found_notification();
			exit;
		}

		Tygh::$app['view']->assign('show_no_products_block', $show_no_products_block);

		$selected_layout = fn_get_products_layout($_REQUEST);
		Tygh::$app['view']->assign('show_qty', true);

		//Tygh::$app['view']->assign('products', $products);
		//Tygh::$app['view']->assign('search', $search);
		Tygh::$app['view']->assign('selected_layout', $selected_layout);

		Tygh::$app['view']->assign('category_data', $category_data);

		// If page title for this category is exist than assign it to template
		if (!empty($category_data['page_title'])) {
			Tygh::$app['view']->assign('page_title', $category_data['page_title']);
		}

		// [Breadcrumbs]

		if (!empty($category_parent_ids)) {

			Registry::set('runtime.active_category_ids', $category_parent_ids);
			$cats = fn_get_category_name($category_parent_ids);
			foreach ($category_parent_ids as $c_id) {
				fn_add_breadcrumb($cats[$c_id], "catalog.view?category=$c_id");
			}
		}
		else
		{
			$items = fn_get_categories_tree();//fn_get_categories();
			Tygh::$app['view']->assign('items', $items);

		}

		fn_add_breadcrumb($category_data['category'], (empty($_REQUEST['features_hash'])) ? '' : "categories.view?category_id=$_REQUEST[category_id]");
		// [/Breadcrumbs]

	} else {
		return array(CONTROLLER_STATUS_NO_PAGE);
	}

	list($products, $search) = fn_cool_get_pictures($params, Registry::get('settings.Appearance.products_per_page'));
	for($i=0; $i< sizeof($products); $i++){
		$products[$i]['assets']['preview']['url']="http://image.shutterstock.com/z/".basename($products[$i]['assets']['preview']['url']);
	}

	Tygh::$app['view']->assign('products', $products);
	Tygh::$app['view']->assign('search', $search);

	//fn_print_die(var_dump($products));
}
