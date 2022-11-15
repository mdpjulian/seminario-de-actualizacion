<?php

include_once( "./database.php");


$json_body = file_get_contents('php://input');
$object = json_decode($json_body);

$description = $object->description;
$id = $object->id;

try
{
	//Todo tipo de validación de información, debe ser realizada aquí de manera obligatoria
	//ANTES de enviar el comando SQL al motor de base de datos.

	$SQLStatement = $connection->prepare("CALL `editGroup`(:id, :description)");
	$SQLStatement->bindParam( ':id', $id );
	$SQLStatement->bindParam( ':description', $description );
	$SQLStatement->execute();

	$status = array( "status"=>'ok', "description"=>'Grupo Editado Satisfactoriamente!' );

    echo json_encode($status);
}
catch( PDOException $connectionException )
{
    $status = array( "status"=>'db-error (edit.php', "description"=>$connectionException->getMessage() );
    echo json_encode($status);
    die();
}

?>
