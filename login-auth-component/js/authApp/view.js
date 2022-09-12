import { AuthController } from "./controller.js";

class AuthView extends HTMLElement{
    constructor(model){
        super();
        this.innerModel = model;
        this.innerController = new AuthController(this,this.innerModel);

        this.form = document.createElement('form');
        this.form.id = "loginForm";

        this.h2Title = document.createElement('h2');
        this.h2Title.innerText = "Login Authorization Screen";

        this.usernameInput = document.createElement('input');
        this.usernameInput.setAttribute("type" , "text");
        this.usernameInput.setAttribute("placeholder" , "Username");
        this.usernameInput.id = "username"

        this.passwordInput = document.createElement('input');
        this.passwordInput.setAttribute("type" , "password");
        this.passwordInput.setAttribute("placeholder" , "Password");
        this.passwordInput.id = "password";

        this.submitButton = document. createElement('button');
        this.submitButton.setAttribute("type" , "submit");
        this.submitButton.innerText = "Login";
    }

    connectedCallback(){
        document.body.appendChild(this.form);
        this.form.appendChild(this.h2Title);
        this.form.appendChild(this.usernameInput);
        this.form.appendChild(this.passwordInput);
        this.form.appendChild(this.submitButton);

        this.form.addEventListener('click', function(event){event.preventDefault()});
        this.submitButton.addEventListener('click', () => this.innerController.onsubmit());
        
    }

    getFormValue(){
        let loginData = 
        {
          username : this.usernameInput.value,
          password : this.passwordInput.value
        }
        return loginData;
      }

}

customElements.define('x-auth', AuthView)
export { AuthView }