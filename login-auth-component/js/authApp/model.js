class AuthModel{
    constructor(){}

    submit(data){
        try{
            return fetch('./backend/auth_bcrypt.php', { method:'post', body: JSON.stringify(data) } ).then( response => response.json() ) ;
        }catch (e) {
        console.log('error in fetch');
        }
    }

}

export { AuthModel }