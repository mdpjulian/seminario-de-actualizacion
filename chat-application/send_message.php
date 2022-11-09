<?php

include_once("./server.php");

$json_body = file_get_contents('php://input');
$object = json_decode($json_body);



$response = send_message($object->sender, $object->target, $object->message);



echo json_encode($response);

?>