require 'rails_helper'

describe FolderAttachment do
  let!(:restricted_access_user) { create(:user, dl_resources: true, dl_locked_resources: false) }
  let(:restricted_search) { FolderAttachment.accessible_by(restricted_access_user) }
  let!(:restricted_folder) { create(:folder, name: 'dog', locked: true) }
  let!(:restricted_attachment ) { create(:attachment, attachable_type: 'Folder', attachment_file_name: 'Doggies2.pdf', attachable_id: restricted_folder.id) }
  let!(:restricted_folder_attachment ) { restricted_attachment.becomes(FolderAttachment) }

  let!(:unrestricted_access_user) { create(:user, dl_resources: true, dl_locked_resources: true) }
  let(:unrestricted_search) { FolderAttachment.accessible_by(unrestricted_access_user) }
  let!(:unrestricted_folder) { create(:folder, name: 'dog', locked: false) }
  let!(:unrestricted_attachment ) { create(:attachment, attachable_type: 'Folder', attachment_file_name: 'Doggies.pdf', attachable_id: unrestricted_folder.id) }
  let!(:unrestricted_folder_attachment ) { unrestricted_attachment.becomes(FolderAttachment) }

  let!(:dog_profile_photo) { create(:attachment, attachable_type: 'Dog', attachment_file_name: 'Doggies.png')}

  let(:all_folder_attachments) { [restricted_folder_attachment, unrestricted_folder_attachment] }

  describe 'default_scope' do
    it "should return only attachments attached to folders" do
      expect(FolderAttachment.all).to match_array [ restricted_folder_attachment, unrestricted_folder_attachment ]
    end
  end

  describe '.accessible_by' do
    let!(:user_with_access){ create(:user, dl_locked_resources: true) }
    let!(:user_without_access){ create(:user, dl_locked_resources: false) }

    describe 'when current user has access privileges' do
      it "should return all folder attachments" do
        expect(FolderAttachment.accessible_by(user_with_access)).to match_array all_folder_attachments
      end
    end

    describe 'when current user does not have access privileges' do
      it "should return only unrestricted folder attachments" do
        expect(FolderAttachment.accessible_by(user_without_access)).to match_array [unrestricted_folder_attachment]
      end
    end
  end

  describe 'inheritance from Attachment class' do
    it "should have .matching class method" do
      expect(FolderAttachment).to respond_to(:matching)
    end
  end
end
