<?php

include_once( "./database.php");


$json_body = file_get_contents('php://input');
$object = json_decode($json_body);

$user_id = $object->user_id;
$group_id = $object->group_id;

try
{
	//Todo tipo de validación de información, debe ser realizada aquí de manera obligatoria
	//ANTES de enviar el comando SQL al motor de base de datos.

	$SQLStatement = $connection->prepare("CALL `addUserToGroup`(:user_id, :group_id)");
	$SQLStatement->bindParam( ':user_id', $user_id );
	$SQLStatement->bindParam( ':group_id', $group_id );
	$SQLStatement->execute();

	$status = array( "status"=>'ok', "description"=>'Usuario agregado a Grupo Satisfactoriamente!' );

    echo json_encode($status);
}
catch( PDOException $connectionException )
{
    $status = array( "status"=>'db-error (create.php', "description"=>$connectionException->getMessage() );
    echo json_encode($status);
    die();
}

?>
