<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }



    if ($mode == 'update') {
        if (!empty($_REQUEST['setting_data']) &&
            !empty($_REQUEST['setting_id'])
        ) {

            //fn_print_r($_REQUEST['split_data']);
            $settings_id = fn_cool_update_settings(
                $_REQUEST['setting_data'],
                $_REQUEST['setting_id']
            );

            if ($settings_id) {
                return array(
                    CONTROLLER_STATUS_OK,
                    'calc.view'
                );
            } else {
                return array(CONTROLLER_STATUS_NO_PAGE);
            }
        } else {
            return array(CONTROLLER_STATUS_NO_PAGE);
        }

    }
    if ($mode == 'view')
    {

        $data = fn_cool_get_settings('1');
        Tygh::$app['view']->assign('settings_data', $data);

    }
