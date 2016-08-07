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
      @adopters = @adopters.where('adopters.name ILIKE ?', "%#{@params[:search].strip}%").order(id: :desc)
    elsif active_status_search?
      @adopters = @adopters.where('status IN (?)', STATUSES).order(id: :desc)
    elsif status_search?
      @adopters = @adopters.where(status: @params[:status]).order(id: :desc)
    end

    with_includes
    for_page(@params[:page])

    @adopters
  end

  def self.search(params: {})
    self.new(params: params).search
  end

  private

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
