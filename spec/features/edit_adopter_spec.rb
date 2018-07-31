require 'rails_helper'

feature 'Edit Adopter Form', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:adopter) { create(:adopter_with_app) }

  scenario 'Admin edits adopter' do
    sign_in(admin)
    visit adopter_path(adopter)

    expect(page).to have_content(adopter.name)
    expect(page).to have_content(adopter.email)

    expect(first('.read-only', visible: false)).to be_visible
    expect(first('.editable', visible: false)).not_to be_visible

    find('#toggle-edit').click

    expect(first('.read-only', visible: false)).not_to be_visible
    expect(first('.editable', visible: false)).to be_visible

    find('#toggle-edit').click

    expect(first('.read-only', visible: false)).to be_visible
    expect(first('.editable', visible: false)).not_to be_visible
  end

  scenario 'Add comment' do
    adopter.update_attribute(:email, 'norm@acme.co.uk') # create an update audit item
    sign_in(admin)
    visit adopter_path(adopter)
    expect(page).to have_selector('.read-only-comment', count: 1)
    expect(page).to have_selector('.comment-header', count: 1)
    fill_in('comment_content', with: "bish bash bosh")
    page.find('#comment_submit').click
    expect(page).to have_selector('.read-only-comment', count: 2)
    expect(page).to have_selector('.comment-header', count: 2)
    expect(adopter.comments.count).to eq 2

    click_link('All')
    # 2 comments
    expect(page).to have_selector('.comment-header', count: 2)
    expect(page).to have_selector('.read-only-comment', count: 2)
    # 2 audit items
    expect(page).to have_selector('.audit-header', count: 2) # create, update
    expect(page).to have_selector('.change-audit-item', count: 1) # update

    click_link('History')
    expect(page).not_to have_selector('.read-only-comment')
    expect(page).not_to have_selector('.comment-header')
    expect(page).to have_selector('.change-audit-item', count: 1) # update
    expect(page).to have_selector('.audit-header', count: 2) # create and update
  end

  xscenario "should warn user if comment field is blank" do
    expect(1).to eq 0
  end

  xscenario 'Edit comment' do
    expect(2).to eq 1
  end

  xscenario 'edit comment to blank' do
    expect(2).to eq 1
  end
end
