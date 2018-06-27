require 'rails_helper'
require_relative '../helpers/dog_show_helper'
require_relative '../helpers/rspec_matchers'

feature 'visit dog show page', js: true do
  include DogShowHelper
  let!(:active_user) { create(:user) }

  before do
    sign_in(active_user)
  end

  context "dog is unavailable" do
    before(:each) do
      visit dogs_manager_path(adoption_completed_dog)
    end

    ["adopted", "completed", "not available"].each do |status|
      context "when the dog adoption is #{status}" do
        let(:adoption_completed_dog){FactoryBot.create(:dog, status: status)}
        it 'should show alert to inform user' do
          expect(page).to have_selector('.alert.alert-danger h4', text: "Sorry, this dog is no longer available for adoption!")
          expect(page).to have_selector('.alert.alert-danger', text: "Please see our gallery of")
          expect(page).to have_selector('.alert.alert-danger a', text: "available dogs")
        end
      end
    end
  end

  context "adoptapet ad text" do
    before(:each) do
      visit dogs_manager_path(dog)
    end

    context "dog does not have a foster" do
      let(:dog){ FactoryBot.create(:dog, foster_id: nil) }

      it "should indicate Adoptapet ad needs foster" do
        expect(adoptapet_ad).to eq "Foster needed for Adoptapet"
      end
    end

    context "dog foster is out-of-region" do
      let(:foster){ FactoryBot.create(:foster, region: "CA") }
      let(:dog){ FactoryBot.create(:dog, foster_id: foster.id) }

      it "should indicate Adoptapet N/A" do
        expect(adoptapet_ad).to eq "Adoptapet N/A for CA"
      end
    end

    context "dog foster is in-region" do
      let(:region){ "VA" }
      let(:foster){ FactoryBot.create(:foster, region: region) }
      let(:dog){ FactoryBot.create(:dog, foster_id: foster.id) }

      it "should have a link to the Adoptapet ad" do
        expect(adoptapet_ad_link).to eq Adoptapet.new(region).url
        expect(page).to have_selector("#adoptapet_ad a", text: "Adoptapet VA")
      end
    end
  end

  context 'dog attributes unpopulated' do
    let(:dog){ create(:dog,
                      original_name: nil,
                      microchip: nil,
                      fee: nil,
                      shelter: nil,
                      available_on_dt: nil,
                      intake_dt: nil,
                      adoption_date: nil,
                      first_shots: nil,
                      second_shots: nil,
                      third_shots: nil,
                      rabies: nil,
                      vac_4dx: nil,
                      bordetella: nil,
                      heartworm_preventative: nil,
                      flea_tick_preventative: nil) }

    it "page shows default text for unknown attributes" do
      visit dogs_manager_path(dog)
      expect(page.find('#original_name').text).to eq 'unknown'
      expect(page.find('#microchip').text).to eq 'unknown'
      expect(page.find('#fee').text).to eq 'unknown'
      expect(page.find('#shelter').text).to eq 'unknown'
      expect(page.find('#adopters').text).to eq 'no adopters'
      expect(page.find('#available_on_dt').text).to eq 'unknown'
      expect(page.find('#intake_dt').text).to eq 'unknown'
      expect(page.find('#adoption_date').text).to eq 'unknown'
      expect(page.find('#first_shots')).to have_x_icon
      expect(page.find('#second_shots')).to have_x_icon
      expect(page.find('#third_shots')).to have_x_icon
      expect(page.find('#rabies')).to have_x_icon
      expect(page.find('#vac_4dx')).to have_x_icon
      expect(page.find('#bordetella')).to have_x_icon
      expect(page.find('#heartworm_preventative')).to have_x_icon
      expect(page.find('#flea_tick_preventative')).to have_x_icon
    end
  end

end # /feature
