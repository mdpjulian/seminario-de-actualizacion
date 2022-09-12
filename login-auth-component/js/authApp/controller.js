class AuthController
{
    constructor(view, model)
    {
        this.innerModel = model;
        this.innerView = view;
    }

    onsubmit(){
        this.innerModel.submit(this.innerView.getFormValue()).then( response => {console.log(JSON.stringify(response))});
    }    
}

export { AuthController }
