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
class FolderAttachment < Attachment
  belongs_to :folder, foreign_key: :attachable_id
  default_scope { where(attachable_type: 'Folder') }
  scope :accessible_by, ->(user){ joins(:folder).merge(Folder.accessible_by(user)) }
end
