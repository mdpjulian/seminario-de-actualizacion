class AuthView extends HTMLElement{
    constructor(model){
        super();
        this.innerModel = model;

    }

    connectedCallback(){}

}

customElements.define('x-authApp', AuthView)
export { AuthView }