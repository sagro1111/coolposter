<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

use Tygh\Session;
use Tygh\Registry;

$secret = Registry::get('addons.ip5_google_recaptcha.secretkey');

if (!empty($secret)) {
    $reCaptcha = new ReCaptcha($secret);
    if (!empty($_REQUEST['g-recaptcha-response'])) {
        $resp = $reCaptcha->verifyResponse(
            $_SERVER['REMOTE_ADDR'],
            $_REQUEST['g-recaptcha-response']
        );
        if ($resp != null && $resp->success) {
            $_SESSION['image_verification_ok'] = true;
        }
    }    
}
