<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_ip5_pages_in_blocks_post_get_pages(&$pages, $params, $lang_code)
{
	if (!empty($params['get_additions']) && !empty($pages)) {
		foreach ($pages as &$p) {
			if ($p['page_type'] == PAGE_TYPE_FORM && Registry::get('addons.form_builder.status') == 'A') {
				list($p['form']['elements'], $p['form']['general']) = fn_get_form_elements($p['page_id'], true);
			} elseif ($p['page_type'] == PAGE_TYPE_POLL && Registry::get('addons.polls.status') == 'A') {
				$p['poll'] = fn_get_poll_data($p['page_id'], $lang_code);
			}
		}
	}
}

function fn_ip5_pages_in_blocks_get_pages($params, $join, &$condition, $fields, $group_by, $sortings, $lang_code)
{
	if (!empty($params['avail_types'])) {
		$condition .= db_quote(" AND ?:pages.page_type IN (?a)", $params['avail_types']);
	}
}