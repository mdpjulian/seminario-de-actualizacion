<?php


function connect_users( $id_user_a, $id_user_b )
{


    return generate_key('A','B');
}

function disconnect_users( $id_user_a, $id_user_b )
{

}

function send_message( $id_user_sender, $id_user_target, $body_message )
{
    session_start(); 
    $_SESSION['Chat'] = array('sender' => $id_user_sender, 'target' => $id_user_target, 'message' => $body_message );
    return get_messages($id_user_target);
}



function generate_key( $id_user_sender, $id_user_target )
{
    return hash('sha256', uniqid() );
}

function get_messages( $id_user )
{
    session_start();
    if($id_user == $_SESSION['Chat']['target']){
        return $_SESSION['Chat']['message'];
    }
}



?>