<?php

$schema['central']['website']['items']['coolposter'] = array(
	'attrs' => array(
		'class'=>'is-addon'
	),
	'href' => 'coolposter.manage',
	'position' => 500
);

$schema['central']['website']['items']['coolposter']['subitems']['cool_splits'] = array(
	'href' => 'coolposter.manage',
	'position' => 10
);
$schema['central']['website']['items']['coolposter']['subitems']['cool_calc'] = array(
	'href' => 'calc.view',
	'position' => 11
);
return $schema;