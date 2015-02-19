class DogSearcher
  def initialize(params: {}, manager: false)
    @params = params
    @manager = manager
  end

  def search
    if @manager
      if (@params[:search].to_i > 0)
        dogs = Dog.where('tracking_id = ?', "#{@params[:search].to_i}").paginate(:page => @params[:page])
      elsif @params[:search]
        dogs = Dog.where('lower(name) LIKE ?', "%#{@params[:search].downcase.strip}%").paginate(:page => @params[:page])
      elsif @params[:status] == 'active'
        statuses = ['adoptable', 'adoption pending', 'on hold', 'return pending', 'coming soon']
        dogs = Dog.where("status IN (?)", statuses).order(sort_column + ' ' + sort_direction).paginate(:per_page => 30, :page => @params[:page]).includes(:photos, :primary_breed)
      elsif @params.has_key? :status
        dogs = Dog.where(:status => @params[:status]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 30, :page => @params[:page]).includes(:photos, :primary_breed)
      else
        dogs = Dog.where("name ilike ?", "%#{@params[:q]}%").order(sort_column + ' ' + sort_direction).paginate(:per_page => 30, :page => @params[:page]).includes(:photos, :primary_breed)
      end
    else
      statuses = ['adoptable', 'adoption pending', 'coming soon']
      dogs = Dog.where("status IN (?)", statuses).order(sort_column + ' ' + sort_direction).paginate(:per_page => 30, :page => @params[:page]).includes(:photos, :primary_breed)
    end
    dogs
  end

  def self.search(params: {}, manager: false)
    self.new(params: params, manager: manager).search
  end

  def sort_column
    Dog.column_names.include?(@params[:sort]) ? @params[:sort] : 'tracking_id'
  end

  def sort_direction
    %w[asc desc].include?(@params[:direction]) ? @params[:direction] : 'asc'
  end
end
