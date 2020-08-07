require 'rails_helper'
require_relative '../helpers/application_helpers'

feature "folder management", js: true do
  include ApplicationHelpers

  describe "folder index" do
    describe "when user is not admin" do
      it "should redirect to signin page" do
        visit folders_path
        expect(page_heading).to eq "Staff Sign in"
      end
    end

    describe "when user is admin" do
      before do
        sign_in_as_admin
      end

      describe "when there are no folders" do
        before do
          visit folders_path
        end

        it "shows 'no folders' message" do
          expect(page_heading).to eq "Staff Resources"
          expect(page).to have_selector("h3", text: "No folders found")
        end
      end

      describe "when there are folders" do
        let!(:locked_folder){ create(:folder, :locked) }
        let!(:unlocked_folder){ create(:folder, :unlocked) }
        before do
          visit folders_path
        end

        it "lists all folders" do
          expect(page_heading).to eq "Staff Resources"
          expect(page).not_to have_selector("span", text: "No Folders")
          expect(page).to have_selector(".folder", count: 2)
          expect(page).to have_selector(".folder .fa-lock", count: 1)
          expect(page).to have_selector(".folder .fa-unlock", count: 1)
        end
      end

      describe "add a folder" do
        before do
          visit folders_path
          click_link("New Folder")
        end

        it "should save a locked-access folder" do
          expect(page_heading).to eq "Create a New Folder"
          fill_in("folder_name", with: "Medical Resources")
          choose("Restricted Folder")
          expect{ click_button("Submit") }.to change{ Folder.count }.by 1
          expect(page_heading).to eq "Staff Resources"
          expect(flash_success_message).to eq "New Folder Added"
          expect(page).to have_selector(".folder .fa-lock", count: 1)
        end

        it "should save an unlocked-access folder" do
          expect(page_heading).to eq "Create a New Folder"
          fill_in("folder_name", with: "Medical Resources")
          choose("Unrestricted Folder")
          expect{ click_button("Submit") }.to change{ Folder.count }.by 1
          expect(page_heading).to eq "Staff Resources"
          expect(flash_success_message).to eq "New Folder Added"
          expect(page).to have_selector(".folder .fa-unlock", count: 1)
        end
      end

      describe "add folder with blank name" do
        before do
          visit folders_path
          click_link("New Folder")
        end

        it "should not save and should warn user" do
          expect(page_heading).to eq "Create a New Folder"
          expect{ click_button("Submit") }.not_to change{ Folder.count }
          expect(page_heading).to eq "Create a New Folder"
          expect(flash_error_message).to include "1 error"
        end
      end
    end
  end

  describe "edit a folder" do
    let(:folder){ create(:folder, :locked) }

    describe "user is admin" do
      let(:admin){ create(:user, :admin) }
      before do
        sign_in_as_admin
        visit edit_folder_path(folder)
      end

      describe "with valid attributes" do
        it "should save the new attributes" do
          expect(page_heading).to eq "Edit Folder"
          fill_in(:folder_name, with: "new folder name")
          choose("Unrestricted Folder")
          expect{ click_button('Submit'); page.find('h1',text: 'new folder name') }.
            to change{Folder.first.name}.to("new folder name").
            and change{Folder.first.locked}.to false
          expect(flash_success_message).to eq "Folder updated"
        end
      end

      describe "with invalid attributes" do
        it "should not save and should warn the user" do
          expect(page_heading).to eq "Edit Folder"
          fill_in(:folder_name, with: "")
          expect{ click_button('Submit') }.not_to change{Folder.first.name}
          expect(page_heading).to eq "Edit Folder"
          expect(flash_error_message).to include "1 error"
        end
      end
    end

    describe "user is not admin" do
      it "should notify user that they are not permitted and redirect to sign in page" do
        visit edit_folder_path(folder)
        expect(page_heading).to eq "Staff Sign in"
        expect(flash_notice_alert_message).to eq "Please sign in to continue."
      end
    end
  end

  describe "show a folder" do
    let(:admin){ create(:user, :admin) }
    let(:folder){ create(:folder, :locked) }

    context 'when the folder is empty' do
      before do
        sign_in_as_admin
      end

      it "should show 'no files' message" do
        visit folder_path(folder)
        expect(page).to have_selector('h3', text: "Folder is empty")
      end
    end

    context 'when the folder contains files' do
      let!(:resource){ create(:attachment, :downloadable, attachment_file_name: "foobar.pdf", updated_by_user_id: admin.id, attachable_id: folder.id, attachable_type: 'Folder') }

      before do
        sign_in_as_admin
        visit folder_path(folder)
      end

      it "should show list of attachments" do
        expect(page).to have_button('//[@id="foobar_1"]')
        expect(page).to have_selector('.attachment input.delete_attachment')
      end
    end

    describe 'upload a file' do
      before do
        sign_in_as_admin
        visit folder_path(folder)
      end

      it "should save the file in the folder", exclude_ie: true do
        expect(page_heading).to eq folder.name
        attach_file('folder_new_attachment_file', Rails.root.join("spec", "fixtures", "doc", "sample.pdf"))
        fill_in('folder_new_attachment_description', with: 'dock docker dockest')
        expect{ page.find('#save_file_button').click }.to change{ FolderAttachment.count }.by(1)
        expect(flash_success_message).to eq "Folder updated"
        expect(page).to have_selector('.attachment', count: 1)
      end
    end
  end

  describe "search for attachments" do
    let(:admin){ create(:user, :admin) }
    let(:folder){ create(:folder, :locked) }
    let!(:resource1){ create(:attachment, attachment_file_name: 'foo_file.pdf', updated_by_user_id: admin.id, attachable_id: folder.id, attachable_type: 'Folder') }
    let!(:resource2){ create(:attachment, attachment_file_name: 'bar_file.pdf', updated_by_user_id: admin.id, attachable_id: folder.id, attachable_type: 'Folder') }

    before do
      sign_in_as_admin
    end

    it "should show matching search results" do
      visit folders_path
      expect(page).to have_selector('#folders .folder', count: 1)
      fill_in('search', with: 'bar')
      page.find('#fetch_files').click
      expect(page).to have_selector('.attachment', count: 1)
      expect(page).to have_selector('.attachment .description', text: '')
      expect(page).not_to have_selector('.attachment input.delete_attachment')
    end
  end

  describe "edit a resource" do
    let(:folder){ create(:folder, :locked) }
    let!(:resource){ create(:attachment, attachable_type: 'Folder', attachable_id: folder.id) }

    context "when user is admin" do
      let(:admin){ create(:user, :admin) }

      before do
        sign_in_as_admin
        visit folder_path(folder)
      end

      it "should save edited description" do
        page.find('.edit_description').click
        fill_in('file_description', with: "new file description")
        expect{ page.find('.save_edit').click; wait_for_ajax }.to change{ Attachment.first.description }.to "new file description"
        expect(page.find('.attachment .description').text).to eq "new file description"
        expect(page).to have_selector('.attachment .edit_description_container .edit_description')
        expect(page).not_to have_selector('.attachment .edit_description_container .cancel_edit')
        expect(page).not_to have_selector('.attachment .edit_description_container .save_edit')
      end
    end

    context "when user is not admin" do
      let(:folder){ create(:folder, :locked) }
      let!(:resource){ create(:attachment, attachable_type: 'Folder', attachable_id: folder.id) }

      before do
        visit folder_path(folder)
      end

      it "should not work" do
        expect(page).not_to have_selector('.edit_description')
      end
    end
  end

  describe "delete a resource" do
    describe "when user is admin" do
      let(:folder){ create(:folder, :locked) }
      let!(:resource){ create(:attachment, attachable_type: 'Folder', attachable_id: folder.id) }
      let(:admin){ create(:user, :admin) }

      before do
        sign_in_as_admin
        visit folder_path(folder)
      end

      it "should delete the file" do
        expect{ page.find('input.delete_attachment').click }.to change{ Attachment.count }.by(-1)
        expect(page).not_to have_selector('.attachment')
      end
    end

  end
end
