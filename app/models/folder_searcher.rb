class FolderSearcher
  def initialize(user, params: {})
    @user = user
    @params = params
  end

  def search
    query = 'attachment_file_name ILIKE :search OR description ILIKE :search'
    search = "%#{search_term.strip}%"
    attachment = Attachment.where(query, search: search).reject do |a|
      locked_folder?(a) && !@user.dl_locked_resources?
    end.compact

    attachment
  end

  def self.search(user, params: {})
    new(user, params: params).search
  end

  private

  def search_term
    @params[:search]
  end

  def locked_folder?(a)
    Folder.find_by_id(a.attachable_id).locked?
  end

  # def for_page(page = nil)
  #   @folder = @folder.paginate(per_page: PER_PAGE, page: page || 1)
  # end
end
