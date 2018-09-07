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
          fill_in("folder_description", with: "put medical stuff here")
          choose("Restricted Folder")
          expect{ click_button("Submit") }.to change{ Folder.count }.by 1
          expect(page_heading).to eq "Staff Resources"
          expect(flash_success_message).to eq "New Folder Added"
          expect(page).to have_selector(".folder .fa-lock", count: 1)
        end

        it "should save an unlocked-access folder" do
          expect(page_heading).to eq "Create a New Folder"
          fill_in("folder_name", with: "Medical Resources")
          fill_in("folder_description", with: "put medical stuff here")
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

      xdescribe "delete a folder" do
        describe "when user does not have restricted folder access" do
          describe "and the folder is restricted" do
            it "should disable the delete icon" do
              expect(1).to eq 0
            end
          end
          describe "and the folder is not restricted" do
            describe "when the folder is empty" do
              it "should delete the folder" do
                expect(1).to eq 0
              end
            end

            describe "when the folder is not empty" do
              it "should not delete the folder, and should warn the user" do
                expect(1).to eq 0
              end
            end
          end
        end

        describe "when user has restricted folder access" do
          describe "when the folder is empty" do
            it "should delete the folder" do
              expect(1).to eq 0
            end
          end

          describe "when the folder is not empty" do
            it "should not delete the folder, and should warn the user" do
              expect(1).to eq 0
            end
          end
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
          fill_in(:folder_description, with: "new folder description")
          choose("Unrestricted Folder")
          expect{ click_button('Submit'); page.find('h1',text: 'new folder name') }.to change{Folder.first.name}.to("new folder name").
                                                                                    and change{Folder.first.description}.to("new folder description").
                                                                                    and change{Folder.first.locked}.to false
          expect(flash_success_message).to eq "Folder Updated"
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
        expect(flash_notice_message).to eq "Please sign in to continue."
      end
    end
  end
end
