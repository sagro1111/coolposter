<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
    'settings_variants_image_verification_use_for',
	'post_add_to_cart',
	'get_order_info',
    'get_products_pre',
    'get_products',
	'add_to_cart',
	'pre_add_to_cart'
   );
