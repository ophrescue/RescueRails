class DogSearcher
  PER_PAGE = 30
  ACTIVE_STATUSES = ['adoptable', 'adoption pending', 'on hold', 'return pending', 'coming soon']
  PUBLIC_STATUSES = ['adoptable', 'adoption pending', 'coming soon']

  def initialize(params: {}, manager: false)
    @params = params
    @manager = manager
  end

  def search
    if @manager
      if tracking_id_search?
        @dogs = Dog.where('tracking_id = ?', "#{@params[:search].to_i}")
      elsif name_search?
        @dogs = Dog.where('lower(name) LIKE ?', "%#{@params[:search].downcase.strip}%")
      elsif active_status_search?
        @dogs = Dog.where("status IN (?)", ACTIVE_STATUSES)
      elsif status_search?
        @dogs = Dog.where(:status => @params[:status])
      else
        @dogs = Dog.where("name ilike ?", "%#{@params[:q]}%")
      end
    else
      @dogs = Dog.where("status IN (?)", PUBLIC_STATUSES)
    end

    with_includes
    with_sorting
    for_page(@params[:page])

    @dogs
  end

  def self.search(params: {}, manager: false)
    self.new(params: params, manager: manager).search
  end

  private

  def tracking_id_search?
    @params[:search].to_i > 0
  end

  def name_search?
    @params[:search].present?
  end

  def active_status_search?
    @params[:status] == 'active'
  end

  def status_search?
    @params.has_key? :status
  end

  def with_includes
    @dogs = @dogs.includes(:photos, :primary_breed)
  end

  def with_sorting
    @dogs = @dogs.order(sort_column + ' ' + sort_direction)
  end

  def for_page(page = nil)
    @dogs = @dogs.paginate(per_page: PER_PAGE, page: page || 1)
  end

  def sort_column
    Dog.column_names.include?(@params[:sort]) ? @params[:sort] : 'tracking_id'
  end

  def sort_direction
    %w[asc desc].include?(@params[:direction]) ? @params[:direction] : 'asc'
  end
end
