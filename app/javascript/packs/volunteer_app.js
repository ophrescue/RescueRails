let fosterToggle = document.getElementById('volunteer_app_fostering_interest');
fosterToggle.addEventListener('click', function (event) {
  document.getElementById('foster-questions').classList.toggle('collapse')
});

let rentToggle = document.getElementById('rent-own-toggle')
rentToggle.addEventListener('change', function (event) {
  console.log(`${event.target.value} is picked`);
  if (event.target.value === 'Rent') {
    document.getElementById('foster-rental-questions').classList.remove('collapse')
  } else {
    document.getElementById('foster-rental-questions').classList.add('collapse')
  }
});

let petsToggle = document.getElementById('other-pets-toggle')
petsToggle.addEventListener('change', function (event) {
  console.log(`${event.target.value} is picked`);
  if (event.target.value === 'true') {
    document.getElementById('other-pets-questions').classList.remove('collapse')
  } else {
    document.getElementById('other-pets-questions').classList.add('collapse')
  }
});

let dogsToggle = document.getElementById('volunteer_app_volunteer_foster_app_attributes_can_foster_dogs');
dogsToggle.addEventListener('click', function (event) {
  document.getElementById('dog-foster-questions').classList.toggle('collapse')
});

// Handle setup and re-rendering of page if there is a server side validation error
window.addEventListener('DOMContentLoaded', function(){
  if (fosterToggle.checked === true) {
    document.getElementById('foster-questions').classList.remove('collapse')
  }
  if (rentToggle.value === 'Rent') {
    document.getElementById('foster-rental-questions').classList.remove('collapse')
  }
  if (petsToggle.checked === true){
    document.getElementById('other-pets-questions').classList.remove('collapse')
  }
  if (dogsToggle.checked === true){
    document.getElementById('dog-foster-questions').classList.remove('collapse')
  }
});
