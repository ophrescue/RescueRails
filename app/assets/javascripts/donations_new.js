//    Copyright 2017 Operation Paws for Homes
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

document.addEventListener("DOMContentLoaded", function () {
    let honorToggle = document.getElementById('honorToggle');
    honorToggle.addEventListener('click', function (event) {
        document.getElementById('honorFields').classList.toggle('collapse')
    });

    let notifyToggle = document.getElementById('notifyToggle');
    notifyToggle.addEventListener('click', function (event) {
        document.getElementById('notifyFields').classList.toggle('collapse')
    });

    let donationAmount = document.getElementById('donation_amount');
    let otherAmount = document.getElementById('otherAmount');

    let otherAmountFunction = function () {
        donationAmount.value = this.value
        console.log('Donation value set to :' + donationAmount.value);
    }

    otherAmount.addEventListener('change', otherAmountFunction);

    let donationButtons = document.getElementsByClassName('donationButton');

    let donationButtonFunction = function() {
        for (let i = 0; i < donationButtons.length; i++ ){
            donationButtons[i].classList.remove('btn-success');
            donationButtons[i].removeAttribute('aria-pressed');
            donationButtons[i].classList.remove('active');
            donationButtons[i].classList.add('btn-primary');
        }
        otherAmount.value = "$0.00";
        this.classList.remove('btn-primary');
        this.classList.add('btn-success');
        donationAmount.value = this.value;
        console.log('Donation value set to :' + donationAmount.value);
    }

    for (let i = 0; i < donationButtons.length; i++ ) {
        donationButtons[i].addEventListener('click', donationButtonFunction);
    }
});
