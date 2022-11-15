<?php

include_once( "./database.php");


$json_body = file_get_contents('php://input');


try
{
	//Todo tipo de validación de información, debe ser realizada aquí de manera obligatoria
	//ANTES de enviar el comando SQL al motor de base de datos.

	$SQLStatement = $connection->prepare("CALL `getAllUsers`()");
	$SQLStatement->execute();
	$response = $SQLStatement->fetchAll(PDO::FETCH_ASSOC);

	
    echo json_encode($response);
}
catch( PDOException $connectionException )
{
    $status = array( "status"=>'db-error (get.php', "description"=>$connectionException->getMessage() );
    echo json_encode($status);
    die();
}

?>
