<?php

include_once( "./database.php");


$json_body = file_get_contents('php://input');
$object = json_decode($json_body);


$password = $object->password;
$username = $object->username;

//to test use: 
//username: bcrypt
//password: carro25

function authenticateUser ($username, $password, $connection){
	

	if($username && $password){
		

		$SQLStatement = $connection->prepare("CALL `auth_user`( :username)");
		$SQLStatement->bindParam( ':username', $username );
		$SQLStatement->execute();
			
		$queryResult = $SQLStatement->fetchall();

		$hashDB = $queryResult[0]["password"];
		$user_id = $queryResult[0]["id"];

		
		if($user_id && password_verify($password, $hashDB)){

			$token = hash('sha256', $username.$hashDB);

			$SQLStatement = $connection->prepare("CALL `create_user_session`(:token, :user_id)");
			$SQLStatement->bindParam( ':token', $token );
			$SQLStatement->bindParam( ':user_id', $user_id );
			$SQLStatement->execute();

			$status = array('status' => 'valid login', 'token' => $token);
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