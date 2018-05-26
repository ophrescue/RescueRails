module Sortable

  def text_search?
    params[:search].present?
  end

  def with_sorting
    if text_search? && unspecified_sort?
      @dogs = @dogs.sort_with_search_term_matches_first(search_term)
    else
      puts "#{@dogs.order( sort = "#{sort_column} #{sort_direction}" ).to_sql}"
      @dogs = @dogs.order( sort = "#{sort_column} #{sort_direction}" )
    end
  end

  def unspecified_sort?
    params[:sort].blank?
  end

  def sort_column
    Dog.column_names.include?(params[:sort]) ? params[:sort] : params[:sort] = 'tracking_id'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : params[:direction] = 'asc'
  end
end
