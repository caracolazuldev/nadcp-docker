<?php

chdir('/var/www/html');

// load CiviCRM
define('CIVICRM_UF', 'WordPress');
require_once './wp-content/plugins/civicrm/civicrm/civicrm.config.php';

// set $contrib_id from the environment
$contrib_id = getenv('CONTRIB_ID');

$params = [
	'receive_date' => ['>' => "2023-01-01"],
    'contribution_page_id' => 2,
    'contribution_status_id' => 'Completed',
	'return' => 'id, contact_id, contribution_status_id',
    'options' => ['limit' => 0],
];

if ($contrib_id) {
	$params['id'] = $contrib_id;
}
$contributions = civicrm_api3('Contribution', 'get', $params)['values'];

var_export($contributions);

foreach ($contributions as $contribution) {
	$record = (object) $contribution;
	try {
		Nadcp\Checkout\Participants\handleCiviCrmHookDatabasePost('', '$objectName', 0, $record);
	} catch (Exception $e) {
		// in case of bad custom-data, probably
		echo $e->getMessage();
	}
}
