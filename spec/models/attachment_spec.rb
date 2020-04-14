# == Schema Information
#
# Table name: attachments
#
#  id                      :integer          not null, primary key
#  attachable_id           :integer
#  attachable_type         :string
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  updated_by_user_id      :integer
#  created_at              :datetime
#  updated_at              :datetime
#  description             :text
#  agreement_type          :string
#
require 'rails_helper'

describe '.matching class method' do
  let!(:foo_attachment){ create(:attachment, attachment_file_name: 'foo.jpg', description: 'bar') }
  let!(:baz_attachment){ create(:attachment, attachment_file_name: 'baz.jpg', description: 'qux') }

  it 'should match file name' do
    expect(Attachment.matching('foo')).to eq [foo_attachment]
  end

  it 'should match description' do
    expect(Attachment.matching('bar')).to eq [foo_attachment]
  end
end
