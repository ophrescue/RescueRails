class FolderSearcher

  def initialize(user, params: {})
    @user = user
    @params = params
  end

  def search
    query = 'attachment_file_name ILIKE :search OR description ILIKE :search'
    @folder = Attachment.where(query, search: "%#{search_term.strip}%").map do |a|
      next if Folder.find_by_id(a.attachable_id.to_i).locked? && ! @user.dl_locked_resources?
      a
    end.compact

    @folder
  end

  def self.search(user, params: {})
    new(user, params: params).search
  end

  private

  def search_term
    @params[:search]
  end

  def for_page(page = nil)
    @folder = @folder.paginate(per_page: PER_PAGE, page: page || 1)
  end
end
