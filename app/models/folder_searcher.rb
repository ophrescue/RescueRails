class FolderSearcher

  def initialize(params: {})
    @params = params
  end

  def search
    query = 'attachment_file_name ILIKE :search OR description ILIKE :search'
    @folder = Attachment.where(query, search: "%#{search_term.strip}%").map do |a|
                a
    end
    @folder
  end


  def self.search(params: {})
    new(params: params).search
  end

  private

  def search_term
    @params[:search]
  end

  def for_page(page = nil)
    @folder = @folder.paginate(per_page: PER_PAGE, page: page || 1)
  end
end
