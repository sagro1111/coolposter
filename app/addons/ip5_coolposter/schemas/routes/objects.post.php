<?php

$schema['/coolposter'] = array(
    'dispatch' => 'coolposter.view'
);

$schema['/calc'] = array(
    'dispatch' => 'coolposter.calc'
);

$schema['/coolload'] = array(
    'dispatch' => 'coolload.view'
);
$schema['/coolcategories'] = array(
    'dispatch' => 'coolcategories.view'
);
$schema['/hits'] = array(
    'dispatch' => 'hits.view'
);
$schema['/catalog'] = array(
    'dispatch' => 'catalog.view'
);
$schema['/popular'] = array(
    'dispatch' => 'popular.view'
);
return $schema;