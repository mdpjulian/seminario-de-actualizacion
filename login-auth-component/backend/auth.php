<?php

include_once( "./database.php");


$json_body = file_get_contents('php://input');
$object = json_decode($json_body);


$password = $object->password;
$username = $object->username;


try{
	if($username && $password){
		//Todo tipo de validación de información, debe ser realizada aquí de manera obligatoria
		//ANTES de enviar el comando SQL al motor de base de datos.

		$SQLStatement = $connection->prepare("CALL `authenticateUser`(:username, :password)");
		$SQLStatement->bindParam( ':username', $username );
		$SQLStatement->bindParam( ':password', $password );
		$SQLStatement->execute();

		
		$queryResult = $SQLStatement->fetchall();

		if($queryResult){
			$status = array('status' => 'correct', 'userid' => $queryResult[0]["id"]);
		}else{
			$status = array('status' => 'invalid', 'description' => "Invalid username or password");
		}
	}else{
		$status = array('status' => 'empty', 'description' => "Username or password empty");
	}

echo json_encode($status);
}catch( PDOException $connectionException ){
	$status = array( 'status' => 'db-error (auth.php)', 'description' => $connectionException->getMessage() );
	echo json_encode($status);
	die();
}

?>
