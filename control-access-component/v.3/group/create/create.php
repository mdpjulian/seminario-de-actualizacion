<?php

include_once( "./database.php");


$json_body = file_get_contents('php://input');
$object = json_decode($json_body);

$description = $object->description;
$name = $object->name;

try
{
	//Todo tipo de validación de información, debe ser realizada aquí de manera obligatoria
	//ANTES de enviar el comando SQL al motor de base de datos.

	$SQLStatement = $connection->prepare("CALL `createGroup`(:name, :description)");
	$SQLStatement->bindParam( ':name', $name );
	$SQLStatement->bindParam( ':description', $description );
	$SQLStatement->execute();

	$status = array( "status"=>'ok', "description"=>'Grupo Creado Satisfactoriamente!' );

    echo json_encode($status);
}
catch( PDOException $connectionException )
{
    $status = array( "status"=>'db-error (create.php', "description"=>$connectionException->getMessage() );
    echo json_encode($status);
    die();
}

?>
