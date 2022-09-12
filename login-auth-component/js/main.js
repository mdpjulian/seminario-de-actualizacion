import {AuthView} from './authApp/view.js'
import {AuthModel} from './authApp/model.js'


function main(){

  let aModel = new AuthModel();

  let aView = new AuthView(aModel);
  document.body.appendChild(aView);

};

window.addEventListener("load", main);