class FolderSearcher

  def initialize(params: {})
    @params = params
  end

  def search
    @folders = Attachment.where('lower(attachment_file_name) LIKE ?', "%#{search_term}%").map do |a|
                    Folder.find_by_id(a.attachable_id.to_i)
               end
    @folders
  end


  def self.search(params: {})
    new(params: params).search
  end




  private

  def text_search?
    @params[:search].present?
  end

  def search_term
    @params[:search]
  end

  def for_page(page = nil)
    @folders = @folders.paginate(per_page: PER_PAGE, page: page || 1)
  end
end
