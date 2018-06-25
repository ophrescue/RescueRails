require 'rails_helper'

feature 'visit dog edit page', js: true do

  before do
    sign_in(active_user)
    visit edit_dog_path( create(:dog) )
  end

  describe 'when user has no privileges' do

    let!(:active_user) { create(:user,
                                add_dogs: false,
                                medical_behavior_permission: false,
                                edit_dogs: false,
                                edit_all_adopters: false) }

    it "does not permit page access" do
      expect(page).to have_current_path root_path
    end
  end

  describe 'when user has add_dog privileges' do

    let!(:active_user) { create(:user,
                                add_dogs: true,
                                medical_behavior_permission: false,
                                edit_dogs: false,
                                edit_all_adopters: false) }

    it "does not permit page access" do
      expect(page).to have_current_path root_path
    end
  end

  describe 'when user has edit_dog privileges' do

    let!(:active_user) { create(:user,
                                add_dogs: false,
                                medical_behavior_permission: false,
                                edit_dogs: true,
                                edit_all_adopters: false) }

    it "permits page access" do
      expect(page).to have_current_path edit_dog_path(Dog.first)
    end
  end
end

feature 'visit new dog page', js: true do

  before do
    sign_in(active_user)
    visit new_dog_path
  end

  describe 'when user has no privileges' do

    let!(:active_user) { create(:user,
                                add_dogs: false,
                                medical_behavior_permission: false,
                                edit_dogs: false,
                                edit_all_adopters: false) }

    it "does not permit page access" do
      expect(page).to have_current_path root_path
    end
  end

  describe 'when user has add_dog privileges' do

    let!(:active_user) { create(:user,
                                add_dogs: true,
                                medical_behavior_permission: false,
                                edit_dogs: false,
                                edit_all_adopters: false) }

    it "permits page access" do
      expect(page).to have_current_path new_dog_path
    end
  end

  describe 'when user has edit_dog privileges' do

    let!(:active_user) { create(:user,
                                add_dogs: false,
                                medical_behavior_permission: false,
                                edit_dogs: true,
                                edit_all_adopters: false) }

    it "does not permit page access" do
      expect(page).to have_current_path root_path
    end
  end
end

