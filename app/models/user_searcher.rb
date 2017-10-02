class UserSearcher
  PER_PAGE = 30
  EMAIL_CHECK = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def initialize(params: {})
    @params = params
  end

  def search
    @users = User

    if text_search?
      if email_search?
        @users = @users.where('lower(email) LIKE ?', "%#{search_term}%")
      else
        @users = @users.where('lower(name) LIKE ?', "%#{search_term}%")
      end
    elsif location_search?
      @users = @users.active.near(@params[:location], 30)
    else
      @users = @users.active.filter(filtering_params).order('name')
    end

    for_page(@params[:page])

    @users
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

  def location_search?
    @params[:location].present?
  end

  def search_term
    @params[:search].to_s.downcase.strip
  end

  def for_page(page = nil)
    @users = @users.paginate(per_page: PER_PAGE, page: page || 1)
  end

  def filtering_params
    @params.slice(:admin, :adoption_coordinator, :event_planner,
                 :dog_adder, :dog_editor, :photographer, :foster,
                 :newsletter, :has_dogs, :has_cats, :house_type, :has_children_under_five,
                 :has_fence, :puppies_ok, :has_parvo_house, :transporter, :training_team, :foster_mentor, :translator, :public_relations, :fundraising, :medical_behavior
                )
  end
end
