<?php

$event_id = 375;

chdir('/var/www/html');

// load CiviCRM
define('CIVICRM_UF', 'WordPress');
require_once './wp-content/plugins/civicrm/civicrm/civicrm.config.php';

// Retrieve Contributions using @event_id that are status, "Completed"
$params = [
    'event_id' => $event_id,
    'contribution_status_id' => 'Completed',
	'return' => 'id, contact_id, contribution_status_id',
    'options' => ['limit' => 0],
];
$contributions = civicrm_api3('Contribution', 'get', $params)['values'];

foreach ($contributions as $contribution) {
	$record = (object) $contribution;
	try {
		Nadcp\Checkout\Participants\handleCiviCrmHookDatabasePost('', '$objectName', 0, $record);
	} catch (Exception $e) {
		// in case of bad custom-data, probably
		echo $e->getMessage();
	}
}
