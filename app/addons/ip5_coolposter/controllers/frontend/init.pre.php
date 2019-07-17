<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

$wishlistcount = fn_wishlist_get_count();

if ($wishlistcount == -1) {
	$wishlistcount = 0;
}

//fn_print_die($wishlistcount);

Tygh::$app['view']->assign('whishlistcount', $wishlistcount);
$items = fn_get_categories_tree();//fn_get_categories();

