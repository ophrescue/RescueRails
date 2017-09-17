require 'rails_helper'

describe FolderSearcher do
  describe '.search' do
    let!(:some_access_user) { create(:user, dl_resources: true, dl_locked_resources: false) }
    let!(:all_access_user) { create(:user, dl_resources: true, dl_locked_resources: true) }
    let(:restricted_search) { FolderSearcher.search(some_access_user, params: params) }
    let(:unrestricted_search) { FolderSearcher.search(all_access_user, params: params) }
    let!(:dog_folder_unlocked) {create(:folder, name: 'dog', locked: false)}
    let!(:doggie_file) { create(:attachment, attachment_file_name: 'Doggies.pdf', attachable_id: dog_folder_unlocked.id) }
    let!(:dog_folder_locked) {create(:folder, name: 'dog', locked: true)}
    let!(:doggie2_file) { create(:attachment, attachment_file_name: 'Doggies2.pdf', attachable_id: dog_folder_locked.id) }
    let(:params) { { search: 'Doggies' } }

    context 'normal user searches for file' do
      it 'and results include the correct file in unlocked folder' do
        expect(restricted_search).to match_array(doggie_file)
      end

      it 'and results do not include file found in locked folder' do
        expect(restricted_search).not_to match_array(doggie2_file)
      end
    end

    context 'all_access user searches for file' do
      it 'and results include all correct files' do
        expect(unrestricted_search).to match_array([doggie_file, doggie2_file])
      end
    end
  end
end
