class DogSearcher
  PER_PAGE = 30

  def initialize(params: {}, manager: false)
    @params = params
    @manager = manager
  end

  def search
    if @manager
      if (@params[:search].to_i > 0)
        @dogs = Dog.where('tracking_id = ?', "#{@params[:search].to_i}")
      elsif @params[:search]
        @dogs = Dog.where('lower(name) LIKE ?', "%#{@params[:search].downcase.strip}%")
      elsif @params[:status] == 'active'
        statuses = ['adoptable', 'adoption pending', 'on hold', 'return pending', 'coming soon']
        @dogs = Dog.where("status IN (?)", statuses)
      elsif @params.has_key? :status
        @dogs = Dog.where(:status => @params[:status])
      else
        @dogs = Dog.where("name ilike ?", "%#{@params[:q]}%")
      end
    else
      statuses = ['adoptable', 'adoption pending', 'coming soon']
      @dogs = Dog.where("status IN (?)", statuses)
    end

    includes
    sort
    paginate

    @dogs
  end

  def self.search(params: {}, manager: false)
    self.new(params: params, manager: manager).search
  end

  def includes
    @dogs = @dogs.includes(:photos, :primary_breed)
  end

  def sort
    @dogs = @dogs.order(sort_column + ' ' + sort_direction)
  end

  def paginate
    @dogs = @dogs.paginate(:per_page => PER_PAGE, :page => @params[:page])
  end

  def sort_column
    Dog.column_names.include?(@params[:sort]) ? @params[:sort] : 'tracking_id'
  end

  def sort_direction
    %w[asc desc].include?(@params[:direction]) ? @params[:direction] : 'asc'
  end
end
