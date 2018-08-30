class FolderAttachment < Attachment
  belongs_to :folder, foreign_key: :attachable_id
  default_scope { where(attachable_type: 'Folder') }
  scope :accessible_by, ->(user){ joins(:folder).merge(Folder.accessible_by(user)) }
end
