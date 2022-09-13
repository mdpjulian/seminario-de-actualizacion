<?php

include_once( "./database.php");


$json_body = file_get_contents('php://input');
$object = json_decode($json_body);


$password = $object->password;
$username = $object->username;


function authenticateUser ($username, $password, $connection){
	
	if($username && $password){
	

		$SQLStatement = $connection->prepare("CALL `authenticateUser`(:username, :password)");
		$SQLStatement->bindParam( ':username', $username );
		$SQLStatement->bindParam( ':password', $password );
		$SQLStatement->execute();

		
		$queryResult = $SQLStatement->fetchall();

		if($queryResult){
			$user_id = $queryResult[0]["id"];
			$status = array('status' => 'correct', 'userid' => $user_id);
			//generateToken($user_id);
		}else{
			$status = array('status' => 'invalid', 'description' => "Invalid username or password");
		}
	}else{
		$status = array('status' => 'empty', 'description' => "Username or password empty");
	}

	echo json_encode($status);

}


try{

	authenticateUser($username, $password, $connection);
	
	
	
	

	

}catch( PDOException $connectionException ){
	$status = array( 'status' => 'db-error (auth.php)', 'description' => $connectionException->getMessage() );
	echo json_encode($status);
	die();
}

?>
