class VolunteerAppSearcher
  PER_PAGE = 30
  EMAIL_CHECK = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def initialize(params: {})
    @params = params
  end

  def search
    @volunteer_apps = VolunteerApp
    if text_search?
      if email_search?
        @volunteer_apps = @volunteer_apps.where('lower(email) LIKE ?', "%#{search_term}%")
      else
        @volunteer_apps = @volunteer_apps.where('lower(name) LIKE ?', "%#{search_term}%")
      end
    else
      @volunteer_apps = @volunteer_apps.filter_by_status(@params[:status]) if @params[:status].present?
      @volunteer_apps = @volunteer_apps.filter_by_interest(@params[:interest]) if @params[:interest].present?
    end

    for_page(@params[:page])

    @volunteer_apps
  end

  def self.search(params: {})
    new(params: params).search
  end

  private

  def text_search?
    @params[:search].present?
  end

  def email_search?
    @params[:search].match(EMAIL_CHECK)
  end

  def search_term
    @params[:search].to_s.downcase.strip
  end

  def for_page(page = nil)
    @volunteer_apps = @volunteer_apps.paginate(per_page: PER_PAGE, page: page || 1)
  end

end
