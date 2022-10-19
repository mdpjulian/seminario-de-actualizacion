<?php

include_once( "./database.php");


$json_body = file_get_contents('php://input');
$object = json_decode($json_body);


$password = $object->password;
$username = $object->username;

function createUserSession( $id_user )
{
	$token = hash('sha256', $username.$password);

	$SQLStatement = $connection->prepare("CALL `create_user_session`(:id_user, :token)");
	$SQLStatement->bindParam( ':id_user', $id_user );
	$SQLStatement->bindParam( ':token', $token );
	$SQLStatement->execute();

	return $token;
}

function authenticateUser ($username, $password, $connection){
	

	if($username && $password){
		

		$SQLStatement = $connection->prepare("CALL `auth_user`( :username)");
		$SQLStatement->bindParam( ':username', $username );
		$SQLStatement->execute();
			
		$queryResult = $SQLStatement->fetchall();

		$hashDB = $queryResult[0]["password"];
		$user_id = $queryResult[0]["id"];

		
		// modificar todo para que ande!!!
		if($user_id && password_verify($password, $hashDB)){
			//createUserSession($user_id);
			$status = array('status' => 'valid login', 'userid' => createUserSession($user_id));
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
	$status = array( 'status' => 'db-error (auth_bcrypt.php)', 'description' => $connectionException->getMessage() );
	echo json_encode($status);
	die();
}

?>