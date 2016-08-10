class AdopterSearcher
  PER_PAGE = 30

  STATUSES = [
    'new',
    'pend response',
    'workup',
    'approved'
  ].freeze

  def initialize(params: {})
    @params = params
  end

  def search
    @adopters = Adopter

    if name_search?
      @adopters = @adopters.where('adopters.name ILIKE ?', "%#{@params[:search].strip}%")
    elsif active_status_search?
      @adopters = @adopters.where('status IN (?)', STATUSES)
    elsif status_search?
      @adopters = @adopters.where(status: @params[:status])
    end

    with_includes
    with_sorting
    for_page(@params[:page])

    @adopters
  end

  def self.search(params: {})
    self.new(params: params).search
  end

  private

  def with_sorting
    # if params[:sort] == 'assigned_to' sort by association to adopters.user.name?
    @adopters = @adopters.order(sort_column + ' ' + sort_direction)
  end

  def sort_column
    Adopter.column_names.include?(@params[:sort]) ? @params[:sort] : 'id'
  end

  def sort_direction
    %w(asc desc).include?(@params[:direction]) ? @params[:direction] : 'desc'
  end

  def with_includes
    @adopters = @adopters.includes(:user, :comments, :dogs, :adoption_app)
  end

  def active_status_search?
    @params[:status] == 'active'
  end

  def status_search?
    @params.has_key? :status
  end

  def name_search?
    @params[:search].present?
  end

  def for_page(page = nil)
    @adopters = @adopters.paginate(per_page: PER_PAGE, page: page || 1)
  end
end
