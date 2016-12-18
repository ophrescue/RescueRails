var tagCheckRE = new RegExp("(\\w+)(\\s+)(\\w+)");

var relationshipRegExp = new RegExp('\\b(mother|father|mom|dad|brother|roommate|sister|son|aunt|uncle|cousin|wife|husband|in law|grandfather|grandmother|spouse)\\b','gi');

jQuery.validator.addMethod("tagcheck", function(value, element) {
    return tagCheckRE.test(value);
}, "Full name required.");

jQuery.validator.addMethod("referenceRelationship", function(value, element) {
      return !relationshipRegExp.test(value);
}, "Sorry, references must not be related to you or live with you.")

$(function(){
  $("#new_adopter").formwizard({
    formPluginEnabled: false,
    focusFirstInput : true,
    historyEnabled : true,
    validationEnabled: true,
    disableUIStyles : true,
    inDuration : 200,
    outDuration: 200,
    validationOptions : {
      highlight: function(element, errorClass, validClass) {
               $(element).parents("div[class='control-group']").addClass('error').removeClass(validClass);
        },
          unhighlight: function (element, errorClass, validClass) {
            $(element).parents(".error").removeClass('error');
          },
          errorElement: 'span',
          errorClass: 'error',
          rules: {
            "adopter[name]" : {
              required: true,
                              tagcheck: true,
              maxlength: 50
            },
            "adopter[email]" : {
              required: {
                depends:function(){
                  $(this).val($.trim($(this).val()));
                  return true;
                }
              },
              email: true,
                              maxlength: 250,
                              remote: "/adopters/check_email"
            },
                        "adopter[address1]" : {
                              maxlength: 250
                        },
                        "adopter[address2]" : {
                              maxlength: 250
                        },
                        "adopter[city]" : {
                              required: true,
                              maxlength: 250
                        },
            "adopter[state]" : {
                              required: true,
              minlength: 2,
                              maxlength: 2
            },
            "adopter[zip]" : {
                              required: true,
              digits: true,
              minlength: 5,
              maxlength: 5
            },
                        "adopter[when_to_call]" : {
                              maxlength: 250
                        },
                        "adopter[adoption_app_attributes][spouse_name]" : {
                              maxlength: 250
                        },
                        "adopter[adoption_app_attributes][other_household_names]" : {
                              maxlength: 250
                        },
                        "adopter[adoption_app_attributes][how_did_you_hear]" : {
                              maxlength: 250
                        },
                        "adopter[adoption_app_attributes][ready_to_adopt_dt]" : {
                              required: true,
                              dateISO: true
                        },
                        "adopter[adoption_app_attributes][landlord_name]" : {
                              maxlength: 250
                        },
                        "adopter[adoption_app_attributes][landlord_phone]" : {
                              maxlength: 250
                        },
                        "adopter[adoption_app_attributes][rent_dog_restrictions]" : {
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][rent_costs]" : {
                              maxlength: 250
                        },
                        "adopter[dog_name]" : {
                              maxlength: 250
                        },
                        "adopter[dog_reqs]" : {
                              maxlength: 1000
                        },
                        "adopter[why_adopt]" : {
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][dog_exercise]" : {
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][max_hrs_alone]" : {
                              number: true,
                              required: true
                        },
                        "adopter[adoption_app_attributes][dog_vacation]" : {
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][training_explain]" : {
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][surrender_pet_causes]" : {
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][surrendered_pets]" : {
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][current_pets]" : {
                              required: true,
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][why_not_fixed]" : {
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][current_pets_uptodate_why]" : {
                              maxlength: 1000
                        },
                        "adopter[adoption_app_attributes][vet_info]" : {
                              required: true,
                              maxlength: 1000
                        },
                        "adopter[references_attributes][0][email]" : {
                              required: false,
                              email: true
                        },
                        "adopter[references_attributes][0][relationship]" : {
                              required: true,
                              referenceRelationship: true
                        },
                        "adopter[references_attributes][1][email]" : {
                              required: false,
                              email: true
                        },
                        "adopter[references_attributes][1][relationship]" : {
                              required: true,
                              referenceRelationship: true
                        },
                        "adopter[references_attributes][2][email]" : {
                              required: false,
                              email: true
                        },
                        "adopter[references_attributes][2][relationship]" : {
                              required: true,
                              referenceRelationship: true
                        }
          },
          messages : {
            "adopter[email]" : {remote: "Do not use this form! Please email adopt@ophrescue.org for updates on an existing app or to adopt another dog from us." }
          }
    }
   });
});
