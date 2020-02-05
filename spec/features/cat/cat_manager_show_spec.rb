require 'rails_helper'
require_relative '../../helpers/animal_show_helper'
require_relative '../../helpers/rspec_matchers'
require_relative '../../helpers/client_validation_form_helpers'
require_relative '../../helpers/application_helpers'

feature 'visit cat show page', js: true do
  include AnimalShowHelper
  include ClientValidationFormHelpers
  include ApplicationHelpers

  let!(:active_user) { create(:user) }

  before do
    sign_in_as(active_user)
  end

  context "cat is unavailable" do
    before(:each) do
      visit cats_manager_path(adoption_completed_cat)
    end

    ["adopted", "completed", "not available"].each do |status|
      context "when the cat adoption is #{status}" do
        let(:adoption_completed_cat) { FactoryBot.create(:cat, status: status) }

        it 'should show alert to inform user' do
          expect(page).to have_selector('.alert.alert-danger h4', text: "Sorry, this cat is no longer available for adoption!")
          expect(page).to have_selector('.alert.alert-danger', text: "Please see our gallery of")
          expect(page).to have_selector('.alert.alert-danger a', text: "available cats")
        end
      end
    end
  end

  context "adoptapet ad text" do
    before do
      visit cats_manager_path(cat)
    end

    context "cat does not have a foster" do
      let(:cat){ FactoryBot.create(:cat, foster_id: nil) }

      it "should indicate Adoptapet ad needs foster" do
        expect(adoptapet_ad).to eq "Foster needed for Adoptapet"
      end
    end

    context "cat foster is out-of-region" do
      let(:foster){ FactoryBot.create(:foster, region: "CA") }
      let(:cat){ FactoryBot.create(:cat, foster_id: foster.id) }

      it "should indicate Adoptapet N/A" do
        expect(adoptapet_ad).to eq "Adoptapet N/A for CA"
      end
    end

    context "cat foster is in-region" do
      let(:region){ "VA" }
      let(:foster){ FactoryBot.create(:foster, region: region) }
      let(:cat){ FactoryBot.create(:cat, foster_id: foster.id) }

      it "should have a link to the Adoptapet ad" do
        expect(adoptapet_ad_link).to eq Adoptapet.new(region).url
        expect(page).to have_selector("#adoptapet_ad a", text: "Adoptapet VA")
      end
    end
  end

  context 'cat attributes unpopulated' do
    let(:cat){ create(:cat,
                      status: 'adoption pending',
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
                      felv_fiv_test: nil,
                      flea_tick_preventative: nil,
                      dewormer: nil,
                      coccidia_treatment: nil)}

    it "page shows default text for unknown attributes" do
      visit cats_manager_path(cat)
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
      expect(page.find('#felv_fiv_test')).to have_x_icon
      expect(page.find('#flea_tick_preventative')).to have_x_icon
      expect(page.find('#dewormer')).to have_x_icon
      expect(page.find('#coccidia_treatment')).to have_x_icon
    end
  end

  context 'comments tabs, small screen' do
    let!(:cat){ create(:cat, :adoptable, comments: [create(:comment, user: active_user)]) }
    let!(:comment_id){ cat.comments.first.id }
    before(:each) do
      set_screen_size(:small_screen)
      cat.update_attribute(:status, 'adopted') # create an audited update item
      visit cats_manager_path(cat)
    end

    after(:each) do
      set_screen_size(:large_screen)
    end

    it "should add comment on small screen" do
      expect(page).to have_selector('#comment_table_small')
      expect(page).to have_selector('.read-only-comment', count: 1)
      expect(page).to have_selector('.comment-header', count: 1)
      fill_in('comment_content', with: "bish bash bosh")
      page.find('#comment_submit_small').click
      expect(page).to have_selector('.read-only-comment', count: 2)
      expect(page).to have_selector('.comment-header', count: 2)
      expect(page.find('#new_comment').find('textarea').value).to be_blank
      expect(cat.comments.count).to eq 2
      find_link_and_click('All')
      expect(page).to have_selector('.comment-header', count: 2) # 2 comments
      expect(page).to have_selector('.read-only-comment', count: 2)
      expect(page).to have_selector('.audit-header', count: 2) # create, update
      expect(page).to have_selector('.change-audit-item', count: 1) # update
    end

    it "should warn user if comment field is blank" do
      page.find('#comment_submit_small').click
      expect(validation_error_message_for('comment_content').text).to eq "Content cannot be blank"
      fill_in('comment_content', with: "x")
      expect(validation_error_message_for('comment_content')).not_to be_visible
    end

    it 'should be editable' do
      page.find('a', text:'Edit').click
      page.find('.editable-comment>textarea').set("new comment text")
      click_button('Save')
      expect(page).to have_selector("#comment_content_#{comment_id}", text: "new comment text")
      find_link_and_click('All')
      expect(page).to have_selector("#comment_content_#{comment_id}", text: "new comment text")
    end

    it 'edit comment to blank' do
      page.find('a', text:'Edit').click
      page.find('.editable-comment>textarea').set("")
      click_button('Save')
      within('#comment_table_small .editable-comment') do
        expect(validation_error_message_for('comment_content').text).to eq "Content cannot be blank"
        fill_in('comment_content', with: 'x')
        expect(validation_error_message_for('comment_content')).not_to be_visible
      end
    end

    it "should show audit history on small screen" do
      find_link_and_click('History')
      expect(page).to have_no_selector('.read-only-comment')
      expect(page).to have_selector('.change-audit-item', count: 1) # update
      expect(page).to have_selector('.audit-header', count: 2) # create and update
    end

    it "should show comments and audit history on small screen" do
      find_link_and_click('All')
      expect(page).to have_selector('.comment-header', count: 1)
      expect(page).to have_selector('.read-only-comment', count: 1) # the comment
      expect(page).to have_selector('.change-audit-item', count: 1) # update
      expect(page).to have_selector('.audit-header', count: 2) # create, update
    end
  end

  context 'comments tabs, large screen' do
    let!(:cat){ create(:cat, :adoptable, comments: [create(:comment, user: active_user)]) }
    let!(:comment_id){ cat.comments.first.id }
    before(:each) do
      set_screen_size(:large_screen)
      cat.update_attribute(:status, 'adopted') # create an audited change item
      visit cats_manager_path(cat)
    end

    it "should add comment on large screen" do
      expect(page).to have_selector('#comment_table_large')
      expect(page).to have_selector('.read-only-comment', count: 1)
      expect(page).to have_selector('.comment-header', count: 1)
      fill_in('comment_content', with: "bish bash bosh")
      page.find('#comment_submit_large').click
      expect(page).to have_selector('.read-only-comment', count: 2)
      expect(page).to have_selector('.comment-header', count: 2)
      expect(page.find('#new_comment').find('textarea').value).to be_blank
      expect(cat.comments.count).to eq 2
      find_link_and_click('All')
      expect(page).to have_selector('.comment-header', count: 2) # 2 comments
      expect(page).to have_selector('.read-only-comment', count: 2)
      expect(page).to have_selector('.audit-header', count: 2) # create, update
      expect(page).to have_selector('.change-audit-item', count: 1) # update
    end

    it "should warn user if comment field is blank" do
      page.find('#comment_submit_large').click
      expect(validation_error_message_for('comment_content').text).to eq "Content cannot be blank"
      fill_in('comment_content', with: "x")
      expect(validation_error_message_for('comment_content')).not_to be_visible
    end

    it 'should be editable' do
      page.find('a', text:'Edit').click
      page.find('.editable-comment>textarea').set("new comment text")
      click_button('Save')
      expect(page).to have_selector("#comment_content_#{comment_id}", text: "new comment text")
      find_link_and_click('All')
      expect(page).to have_selector("#comment_content_#{comment_id}", text: "new comment text")
    end

    it 'edit comment to blank' do
      page.find('a', text:'Edit').click
      page.find('.editable-comment>textarea').set("")
      click_button('Save')
      within('#comment_table_large .editable-comment') do
        expect(validation_error_message_for('comment_content').text).to eq "Content cannot be blank"
        fill_in('comment_content', with: 'x')
        expect(validation_error_message_for('comment_content')).not_to be_visible
      end
    end

    it "should show audit history on large screen" do
      find_link_and_click('History')
      expect(page).to have_no_selector('.read-only-comment')
      expect(page).to have_selector('.change-audit-item', count: 1) # update
      expect(page).to have_selector('.audit-header', count: 2) # create and update
    end

    it "should show comments and audit history on large screen" do
      find_link_and_click('All')
      expect(page).to have_selector('.comment-header', count: 1)
      expect(page).to have_selector('.read-only-comment', count: 1) # the comment
      expect(page).to have_selector('.audit-header', count: 2) # create, update
      expect(page).to have_selector('.change-audit-item', count: 1) # update
    end
  end

end # /feature
