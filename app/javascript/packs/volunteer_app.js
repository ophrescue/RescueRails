let fosterToggle = document.getElementById('volunteer_app_fostering_interest');
fosterToggle.addEventListener('click', function (event) {
  if (fosterToggle.checked === true){
    document.getElementById('foster-questions').classList.remove('collapse')
    makeFosterQuestionsRequired(true)
  } else {
    document.getElementById('foster-questions').classList.add('collapse')
    makeFosterQuestionsRequired(false)
  }
});

let rentToggle = document.getElementById('rent-own-toggle')
rentToggle.addEventListener('change', function (event) {
  console.log(`${event.target.value} is picked`);
  if (event.target.value === 'Rent') {
    document.getElementById('foster-rental-questions').classList.remove('collapse')
    makeRentalQuestionsRequired(true)
  } else {
    document.getElementById('foster-rental-questions').classList.add('collapse')
    makeRentalQuestionsRequired(false)
  }
});

let petsToggle = document.getElementById('other-pets-toggle')
petsToggle.addEventListener('change', function (event) {
  console.log(`${event.target.value} is picked`);
  if (event.target.value === 'true') {
    document.getElementById('other-pets-questions').classList.remove('collapse')
    makeHasPetsQuestionsRequired(true)
  } else {
    document.getElementById('other-pets-questions').classList.add('collapse')
    makeHasPetsQuestionsRequired(false)
  }
});

let dogsToggle = document.getElementById('volunteer_app_volunteer_foster_app_attributes_can_foster_dogs');
dogsToggle.addEventListener('click', function (event) {
  if (dogsToggle.checked === true) {
    document.getElementById('dog-foster-questions').classList.remove('collapse')
    makeDogFosterQuestionsRequired(true)
  } else {
    document.getElementById('dog-foster-questions').classList.remove('collapse')
    makeDogFosterQuestionsRequired(false)
  }

});


// Handle setup and re-rendering of page if there is a server side validation error
window.addEventListener('DOMContentLoaded', function(){
  if (fosterToggle.checked === true) {
    document.getElementById('foster-questions').classList.remove('collapse')
    makeFosterQuestionsRequired(true)
  }
  let rentRadio = document.getElementById('volunteer_app_volunteer_foster_app_attributes_home_type_rent')
  if (rentRadio.checked === true ) {
    document.getElementById('foster-rental-questions').classList.remove('collapse')
    makeRentalQuestionsRequired(true)
  }
  let otherPetsRadio = document.getElementById('volunteer_app_volunteer_foster_app_attributes_has_pets_true')
  if (otherPetsRadio.checked === true){
    document.getElementById('other-pets-questions').classList.remove('collapse')
    makeHasPetsQuestionsRequired(true)
  }
  if (dogsToggle.checked === true){
    document.getElementById('dog-foster-questions').classList.remove('collapse')
    makeDogFosterQuestionsRequired(true)
  }
});





let makeFosterQuestionsRequired = function(bool) {
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_about_family").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_foster_experience").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_breed_pref").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_ready_to_foster_dt").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_max_time_alone").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_kept_during_day").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_kept_at_night").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_kept_when_alone").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_0_name").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_0_phone").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_0_email").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_0_relationship").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_1_name").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_1_phone").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_1_email").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_1_relationship").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_2_name").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_2_phone").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_2_email").required = bool;
  document.getElementById("volunteer_app_volunteer_references_attributes_2_relationship").required = bool;
};

let makeRentalQuestionsRequired = function(bool) {
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_rental_restrictions").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_rental_landlord_name").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_rental_landlord_info").required = bool;
}

let makeHasPetsQuestionsRequired = function(bool) {
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_vet_info").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_current_pets").required = bool;
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_current_pets_spay_neuter").required = bool;
}

let makeDogFosterQuestionsRequired = function(bool) {
  document.getElementById("volunteer_app_volunteer_foster_app_attributes_dog_exercise").required = bool;
}
