class WaitlistSearcher
  attr_accessor :params

  PER_PAGE = 30

  def initialize(params: {})
    @params = params
  end

  def search
    @waitlists = Waitlist.includes(:adopters, :dogs)

    for_page(params[:page])
  end

  def self.search(params: {})
    new(params: params).search
  end

  private

  def for_page(page = nil)
    @waitlist = @waitlists.paginate(per_page: PER_PAGE, page: page || 1)
  end
end
