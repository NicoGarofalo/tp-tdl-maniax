// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
//import 'bootstrap';
//import 'bootstrap/dist/css/bootstrap';


console.log("APP JS LOAD?");
//= require jquery
//= require rails-ujs

export function showHolaApp(){
	console.log("SHOW HOLA");
}

export default showHolaApp;