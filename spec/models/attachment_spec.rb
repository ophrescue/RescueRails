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
